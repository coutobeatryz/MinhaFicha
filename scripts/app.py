from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg2
from connection import get_connection

app = Flask(__name__)
app.secret_key = 'sua_chave_secreta_aqui' 

# --- Rotas para renderizar as páginas HTML ---

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
    return render_template("menu_aluno.html")

@app.route("/menu_professor")
def menu_professor():
    return render_template("menu_professor.html")

@app.route("/cadastro_atividade")
def cadastro_atividade():
    return render_template("cadastro_atividade.html")

# ROTA CORRIGIDA (nome da função estava errado)
@app.route("/cadastro_disciplina_professor")
def cadastro_disciplina_professor():
    return render_template("cadastro_disciplina_professor.html")

# --- Novas rotas adicionadas para as páginas existentes ---

@app.route("/aluno_atividades")
def aluno_atividades():
    return render_template("aluno_atividades.html")

@app.route("/atribuir_tarefa")
def atribuir_tarefa():
    return render_template("atribuir_tarefa.html")

@app.route("/cadastro_disciplina")
def cadastro_disciplina():
    return render_template("cadastro_disciplina.html")

@app.route("/detalhe_disciplina")
def detalhe_disciplina():
    # Nota: Idealmente, esta rota seria dinâmica para mostrar detalhes de uma disciplina específica.
    # Exemplo: /disciplina/<id>
    return render_template("detalhe_disciplina.html")

@app.route("/disciplinas_aluno")
def disciplinas_aluno():
    return render_template("disciplinas_aluno.html")

@app.route("/disciplinas_professor")
def disciplinas_professor():
    return render_template("disciplinas_professor.html")

@app.route("/grade_aluno")
def grade_aluno():
    return render_template("grade_aluno.html")

# --- Rotas de Lógica (Formulários POST) ---

@app.route("/registrar/aluno", methods=["POST"])
def registrar_aluno():
    matricula = request.form['matricula']
    nome = request.form['nome']
    email = request.form['email']
    cpf = request.form['cpf']
    curso = request.form['curso']
    
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO academico.pessoas (nome, cpf, email) VALUES (%s, %s, %s) RETURNING pessoa_id",
            (nome, cpf, email)
        )
        pessoa_id = cur.fetchone()[0]

        cur.execute(
            "INSERT INTO academico.alunos (aluno_id, matricula, curso) VALUES (%s, %s, %s)",
            (pessoa_id, matricula, curso)
        )
        
        conn.commit()
        flash("Aluno cadastrado com sucesso! Faça o login.", "success")
    except psycopg2.Error as e:
        conn.rollback()

        if e.pgcode == '23505':
            flash("Erro: CPF, Email ou Matrícula já cadastrados no sistema.", "error")
        else:
            flash(f"Ocorreu um erro no banco de dados: {e}", "error")
    finally:
        cur.close()
        conn.close()
        
    return redirect(url_for("index"))

@app.route("/registrar/professor", methods=["POST"])
def registrar_professor():
    registro = request.form['registro']
    nome = request.form['nome']
    email = request.form['email']
    cpf = request.form['cpf']
    departamento = request.form['departamento']

    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO academico.pessoas (nome, cpf, email) VALUES (%s, %s, %s) RETURNING pessoa_id",
            (nome, cpf, email)
        )
        pessoa_id = cur.fetchone()[0]

        cur.execute(
            "INSERT INTO academico.professores (professor_id, numero_registro, departamento) VALUES (%s, %s, %s)",
            (pessoa_id, registro, departamento)
        )
        
        conn.commit()
        flash("Professor cadastrado com sucesso! Faça o login.", "success")
    except psycopg2.Error as e:
        conn.rollback()
        if e.pgcode == '23505':
             flash("Erro: CPF, Email ou Número de Registro já cadastrados no sistema.", "error")
        else:
            flash(f"Ocorreu um erro no banco de dados: {e}", "error")
    finally:
        cur.close()
        conn.close()
        
    return redirect(url_for("index"))

@app.route("/login", methods=["POST"])
def login():
    role = request.form['role']
    
    conn = get_connection()
    cur = conn.cursor()
    
    if role == 'aluno':
        matricula = request.form['matricula']
        cur.execute("SELECT * FROM academico.alunos WHERE matricula = %s", (matricula,))
        aluno = cur.fetchone()
        cur.close()
        conn.close()
        if aluno:
            return redirect(url_for('menu_aluno'))
        else:
            flash("Matrícula de aluno não encontrada.", "error")
            return redirect(url_for('index'))
            
    elif role == 'professor':
        registro = request.form['registro']
        cur.execute("SELECT * FROM academico.professores WHERE numero_registro = %s", (registro,))
        professor = cur.fetchone()
        cur.close()
        conn.close()
        if professor:
            return redirect(url_for('menu_professor'))
        else:
            flash("Número de registro de professor não encontrado.", "error")
            return redirect(url_for('index'))
    
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(debug=True, port=5000)