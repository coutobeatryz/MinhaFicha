from flask import Flask, render_template, request, redirect, url_for, flash, session
import psycopg2
from connection import get_connection
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'sua_chave_secreta_aqui'

# =============================================================================
# ROTAS DE NAVEGAÇÃO E MENUS PRINCIPAIS
# =============================================================================

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/cadastro_aluno")
def cadastro_aluno():
    return render_template("cadastro_aluno.html")

@app.route("/cadastro_professor")
def cadastro_professor():
    return render_template("cadastro_professor.html")

@app.route("/menu_aluno")
def menu_aluno():
    if 'matricula' not in session:
        flash("Por favor, faça login para acessar esta página.", "error")
        return redirect(url_for('index'))
    
    aluno = None
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "SELECT p.nome, a.curso, a.matricula FROM academico.alunos a "
            "JOIN academico.pessoas p ON a.aluno_id = p.pessoa_id WHERE a.matricula = %s",
            (session['matricula'],)
        )
        aluno_data = cur.fetchone()
        if aluno_data:
            aluno = {"nome": aluno_data[0], "curso": aluno_data[1], "matricula": aluno_data[2]}
    except (psycopg2.Error, TypeError) as e:
        flash(f"Erro ao buscar dados do aluno: {e}", "error")
    finally:
        cur.close()
        conn.close()

    if not aluno:
        session.pop('matricula', None)
        flash("Não foi possível encontrar os dados do aluno. Faça login novamente.", "error")
        return redirect(url_for('index'))

    return render_template("menu_aluno.html", aluno=aluno)


@app.route("/menu_professor")
def menu_professor():
    if 'registro' not in session:
        flash("Por favor, faça login para acessar esta página.", "error")
        return redirect(url_for('index'))
    
    professor = None
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "SELECT p.nome, pr.departamento, pr.numero_registro FROM academico.professores pr "
            "JOIN academico.pessoas p ON pr.professor_id = p.pessoa_id WHERE pr.numero_registro = %s",
            (session['registro'],)
        )
        prof_data = cur.fetchone()
        if prof_data:
            professor = {"nome": prof_data[0], "departamento": prof_data[1], "registro": prof_data[2]}
    except (psycopg2.Error, TypeError) as e:
        flash(f"Erro ao buscar dados do professor: {e}", "error")
    finally:
        cur.close()
        conn.close()
    
    if not professor:
        session.pop('registro', None)
        flash("Não foi possível encontrar os dados do professor. Faça login novamente.", "error")
        return redirect(url_for('index'))
        
    return render_template("menu_professor.html", professor=professor)


# =============================================================================
# ROTAS DE GESTÃO DE DISCIPLINAS PELO PROFESSOR
# =============================================================================

@app.route("/disciplinas_professor", methods=["GET"])
def disciplinas_professor():
    if 'registro' not in session:
        flash("Acesso não autorizado.", "error")
        return redirect(url_for('index'))

    disciplinas = []
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT professor_id FROM academico.professores WHERE numero_registro = %s", (session['registro'],))
        professor_id_result = cur.fetchone()
        
        if professor_id_result:
            professor_id = professor_id_result[0]
            cur.execute(
                "SELECT disciplina_id, nome, codigo FROM academico.disciplinas WHERE professor_id = %s ORDER BY nome",
                (professor_id,)
            )
            disciplinas = [{"id": row[0], "nome": row[1], "codigo": row[2]} for row in cur.fetchall()]
            
    except (psycopg2.Error, TypeError) as e:
        flash(f"Erro ao carregar suas disciplinas: {e}", "error")
    finally:
        cur.close()
        conn.close()

    return render_template("disciplinas_professor.html", disciplinas=disciplinas)


@app.route("/disciplina/<int:disciplina_id>")
def detalhe_disciplina(disciplina_id):
    if 'registro' not in session:
        flash("Acesso não autorizado.", "error")
        return redirect(url_for('index'))

    disciplina = None
    alunos = []
    atividades = []
    conn = get_connection()
    cur = conn.cursor()
    try:
        # 1. Buscar dados da disciplina
        cur.execute("SELECT disciplina_id, nome, codigo FROM academico.disciplinas WHERE disciplina_id = %s", (disciplina_id,))
        disc_data = cur.fetchone()
        if disc_data:
            disciplina = {"id": disc_data[0], "nome": disc_data[1], "codigo": disc_data[2]}

            # 2. Buscar alunos inscritos na disciplina
            cur.execute(
                """
                SELECT p.nome, al.matricula FROM academico.pessoas p
                JOIN academico.alunos al ON p.pessoa_id = al.aluno_id
                JOIN academico.grades_horarias gh ON al.aluno_id = gh.aluno_id
                JOIN academico.grades_disciplinas gd ON gh.grade_id = gd.grade_id
                WHERE gd.disciplina_id = %s ORDER BY p.nome
                """,
                (disciplina_id,)
            )
            alunos = [{"nome": row[0], "matricula": row[1]} for row in cur.fetchall()]
            
            # 3. Buscar atividades já cadastradas para a disciplina
            cur.execute(
                "SELECT atividade_id, titulo, data FROM academico.atividades WHERE disciplina_id = %s ORDER BY data DESC",
                (disciplina_id,)
            )
            atividades = [{"id": row[0], "titulo": row[1], "data": row[2].strftime('%d/%m/%Y')} for row in cur.fetchall()]

    finally:
        cur.close()
        conn.close()
    
    if not disciplina:
        flash("Disciplina não encontrada.", "error")
        return redirect(url_for('disciplinas_professor'))

    return render_template("detalhe_disciplina.html", disciplina=disciplina, alunos=alunos, atividades=atividades)


@app.route("/cadastro_disciplina_professor", methods=["GET"])
def cadastro_disciplina_professor():
    if 'registro' not in session:
        flash("Acesso não autorizado.", "error")
        return redirect(url_for('index'))
    return render_template("cadastro_disciplina_professor.html")


@app.route("/salvar_disciplina", methods=["POST"])
def salvar_disciplina():
    if 'registro' not in session:
        flash("Acesso não autorizado.", "error")
        return redirect(url_for('index'))

    nome = request.form['nome']
    codigo = request.form['codigo']
    carga_horaria = request.form['carga_horaria']

    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT professor_id FROM academico.professores WHERE numero_registro = %s", (session['registro'],))
        professor_id_result = cur.fetchone()

        if professor_id_result:
            professor_id = professor_id_result[0]
            cur.execute(
                "INSERT INTO academico.disciplinas (nome, codigo, carga_horaria, professor_id) VALUES (%s, %s, %s, %s)",
                (nome, codigo, carga_horaria, professor_id)
            )
            conn.commit()
            flash(f"Disciplina '{nome}' cadastrada com sucesso!", "success")
        else:
            flash("Erro: Professor não encontrado.", "error")

    except psycopg2.Error as e:
        conn.rollback()
        if e.pgcode == '23505':
            flash(f"Erro: O código de disciplina '{codigo}' já existe.", "error")
        else:
            flash(f"Ocorreu um erro no banco de dados: {e}", "error")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for('disciplinas_professor'))


# =============================================================================
# ROTAS DE LÓGICA DE ATIVIDADES
# =============================================================================

@app.route("/cadastro_atividade", methods=["GET"])
def cadastro_atividade():
    if 'matricula' not in session and 'registro' not in session:
        flash("Você precisa estar logado para criar atividades.", "error")
        return redirect(url_for('index'))

    disciplinas = []
    user_type = 'aluno' if 'matricula' in session else 'professor'
    
    if user_type == 'professor':
        conn = get_connection()
        cur = conn.cursor()
        try:
            cur.execute("SELECT professor_id FROM academico.professores WHERE numero_registro = %s", (session['registro'],))
            professor_id_result = cur.fetchone()
            if professor_id_result:
                professor_id = professor_id_result[0]
                cur.execute("SELECT disciplina_id, nome FROM academico.disciplinas WHERE professor_id = %s", (professor_id,))
                disciplinas = [{"id": row[0], "nome": row[1]} for row in cur.fetchall()]
        finally:
            cur.close()
            conn.close()

    return render_template("cadastro_atividade.html", disciplinas=disciplinas, user_type=user_type)


@app.route("/atribuir_tarefa/<int:disciplina_id>", methods=["GET", "POST"])
def atribuir_tarefa(disciplina_id):
    if 'registro' not in session:
        flash("Acesso não autorizado.", "error")
        return redirect(url_for('index'))

    conn = get_connection()
    cur = conn.cursor()
    
    cur.execute("SELECT disciplina_id, nome FROM academico.disciplinas WHERE disciplina_id = %s", (disciplina_id,))
    disciplina_data = cur.fetchone()
    if not disciplina_data:
        flash("Disciplina não encontrada.", "error")
        cur.close()
        conn.close()
        return redirect(url_for('disciplinas_professor'))
    
    disciplina = {"id": disciplina_data[0], "nome": disciplina_data[1]}

    if request.method == 'POST':
        try:
            titulo, descricao, data = request.form['nome'], request.form['descricao'], request.form['data']
            cur.execute("SELECT professor_id FROM academico.professores WHERE numero_registro = %s", (session['registro'],))
            professor_id = cur.fetchone()[0]
            
            cur.execute(
                """
                INSERT INTO academico.atividades (titulo, descricao, data, status, tipo, disciplina_id, professor_id)
                VALUES (%s, %s, %s, 'A FAZER', 'ACADEMICA', %s, %s) RETURNING atividade_id
                """, (titulo, descricao, data, disciplina_id, professor_id)
            )
            atividade_id = cur.fetchone()[0]

            cur.execute(
                "SELECT g.aluno_id FROM academico.grades_horarias g JOIN academico.grades_disciplinas gd ON g.grade_id = gd.grade_id WHERE gd.disciplina_id = %s",
                (disciplina_id,)
            )
            alunos_da_disciplina = cur.fetchall()
            if alunos_da_disciplina:
                valores_para_inserir = [(aluno[0], atividade_id) for aluno in alunos_da_disciplina]
                cur.executemany("INSERT INTO academico.alunos_atividades (aluno_id, atividade_id) VALUES (%s, %s)", valores_para_inserir)
            
            conn.commit()
            flash(f"Tarefa '{titulo}' atribuída com sucesso!", "success")
        except (psycopg2.Error, TypeError) as e:
            conn.rollback()
            flash(f"Erro ao atribuir tarefa: {e}", "error")
        finally:
            cur.close()
            conn.close()
        return redirect(url_for('detalhe_disciplina', disciplina_id=disciplina_id))

    cur.close()
    conn.close()
    return render_template("atribuir_tarefa.html", disciplina=disciplina)


@app.route("/salvar_atividade", methods=["POST"])
def salvar_atividade():
    if 'matricula' not in session:
        flash("Acesso não autorizado.", "error")
        return redirect(url_for('index'))

    titulo = request.form['titulo']
    descricao = request.form.get('descricao', '')
    data_entrega = request.form['data']
    tipo = request.form['tipo']

    conn = get_connection()
    cur = conn.cursor()
    try:
        if tipo == 'pessoal' and 'matricula' in session:
            cur.execute("SELECT aluno_id FROM academico.alunos WHERE matricula = %s", (session['matricula'],))
            aluno_id_result = cur.fetchone()
            if aluno_id_result:
                aluno_id = aluno_id_result[0]
                cur.execute(
                    """
                    INSERT INTO academico.atividades (titulo, descricao, data, status, tipo, aluno_criador_id)
                    VALUES (%s, %s, %s, 'A FAZER', 'PESSOAL', %s)
                    """,
                    (titulo, descricao, data_entrega, aluno_id)
                )
                flash("Atividade pessoal criada com sucesso!", "success")
            else:
                flash("Erro: Aluno não encontrado.", "error")

        conn.commit()
    except (psycopg2.Error, TypeError) as e:
        conn.rollback()
        flash(f"Ocorreu um erro ao salvar a atividade: {e}", "error")
    finally:
        cur.close()
        conn.close()
    
    return redirect(url_for('aluno_atividades'))


@app.route("/aluno_atividades", methods=["GET"])
def aluno_atividades():
    if 'matricula' not in session:
        flash("Por favor, faça login para acessar esta página.", "error")
        return redirect(url_for('index'))

    atividades = []
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT aluno_id FROM academico.alunos WHERE matricula = %s", (session['matricula'],))
        aluno_id_result = cur.fetchone()
        if not aluno_id_result:
            return redirect(url_for('index'))
        
        aluno_id = aluno_id_result[0]

        # Busca atividades ACADÊMICAS
        cur.execute(
            """
            SELECT at.titulo, at.descricao, at.data, at.status, d.nome, at.tipo
            FROM academico.atividades at
            JOIN academico.alunos_atividades aa ON at.atividade_id = aa.atividade_id
            JOIN academico.disciplinas d ON at.disciplina_id = d.disciplina_id
            WHERE aa.aluno_id = %s AND at.tipo = 'ACADEMICA'
            """,
            (aluno_id,)
        )
        for row in cur.fetchall():
            atividades.append({
                "titulo": row[0], "descricao": row[1], "data": row[2].strftime('%d/%m/%Y') if row[2] else 'N/D',
                "status": row[3], "disciplina": row[4], "tipo": row[5]
            })

        # Busca atividades PESSOAIS
        cur.execute(
            """
            SELECT titulo, descricao, data, status, tipo
            FROM academico.atividades
            WHERE aluno_criador_id = %s AND tipo = 'PESSOAL'
            """,
            (aluno_id,)
        )
        for row in cur.fetchall():
            atividades.append({
                "titulo": row[0], "descricao": row[1], "data": row[2].strftime('%d/%m/%Y') if row[2] else 'N/D',
                "status": row[3], "disciplina": "Pessoal", "tipo": row[4]
            })

        atividades.sort(key=lambda x: datetime.strptime(x['data'], '%d/%m/%Y') if x['data'] != 'N/D' else datetime.max)

    finally:
        cur.close()
        conn.close()

    return render_template("aluno_atividades.html", atividades=atividades)


# =============================================================================
# ROTAS DE REGISTRO E LOGIN
# =============================================================================

@app.route("/registrar/aluno", methods=["POST"])
def registrar_aluno():
    matricula, nome, email, cpf, curso = request.form['matricula'], request.form['nome'], request.form['email'], request.form['cpf'], request.form['curso']
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("INSERT INTO academico.pessoas (nome, cpf, email) VALUES (%s, %s, %s) RETURNING pessoa_id", (nome, cpf, email))
        pessoa_id = cur.fetchone()[0]
        cur.execute("INSERT INTO academico.alunos (aluno_id, matricula, curso) VALUES (%s, %s, %s)", (pessoa_id, matricula, curso))
        conn.commit()
        flash("Aluno cadastrado com sucesso!", "success")
    except psycopg2.Error as e:
        conn.rollback()
        flash(f"Erro ao cadastrar: {e.pgerror}", "error")
    finally:
        cur.close()
        conn.close()
    return redirect(url_for("index"))

@app.route("/registrar/professor", methods=["POST"])
def registrar_professor():
    registro, nome, email, cpf, depto = request.form['registro'], request.form['nome'], request.form['email'], request.form['cpf'], request.form['departamento']
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("INSERT INTO academico.pessoas (nome, cpf, email) VALUES (%s, %s, %s) RETURNING pessoa_id", (nome, cpf, email))
        pessoa_id = cur.fetchone()[0]
        cur.execute("INSERT INTO academico.professores (professor_id, numero_registro, departamento) VALUES (%s, %s, %s)", (pessoa_id, registro, depto))
        conn.commit()
        flash("Professor cadastrado com sucesso!", "success")
    except psycopg2.Error as e:
        conn.rollback()
        flash(f"Erro ao cadastrar: {e.pgerror}", "error")
    finally:
        cur.close()
        conn.close()
    return redirect(url_for("index"))

@app.route("/login", methods=["POST"])
def login():
    role = request.form['role']
    conn = get_connection()
    cur = conn.cursor()
    try:
        if role == 'aluno':
            matricula = request.form['matricula']
            cur.execute("SELECT matricula FROM academico.alunos WHERE matricula = %s", (matricula,))
            if cur.fetchone():
                session['matricula'] = matricula
                return redirect(url_for('menu_aluno'))
            flash("Matrícula de aluno não encontrada.", "error")
        elif role == 'professor':
            registro = request.form['registro']
            cur.execute("SELECT numero_registro FROM academico.professores WHERE numero_registro = %s", (registro,))
            if cur.fetchone():
                session['registro'] = registro
                return redirect(url_for('menu_professor'))
            flash("Número de registro de professor não encontrado.", "error")
    finally:
        cur.close()
        conn.close()
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(debug=True, port=5000)