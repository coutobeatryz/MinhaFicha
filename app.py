from flask import Flask, render_template, request, redirect, url_for
from connection import get_connection

app = Flask(__name__)

# Página inicial com formulário
@app.route("/")
def index():
    return render_template("index.html")

# Rota para salvar grade
@app.route("/adicionar_grade", methods=["POST"])
def adicionar_grade():
    aluno_id = request.form["aluno_id"]
    horarios = request.form["horarios"]

    conn = get_connection()
    cur = conn.cursor()

    try:
        # Inserindo ou atualizando grade
        cur.execute("""
            INSERT INTO academico.grades_horarias (aluno_id, horarios)
            VALUES (%s, %s)
            ON CONFLICT (aluno_id) DO UPDATE SET horarios = EXCLUDED.horarios;
        """, (aluno_id, horarios))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return f"Erro: {e}"
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("index"))

if __name__ == "__main__":
    app.run(debug=True, port=5000)