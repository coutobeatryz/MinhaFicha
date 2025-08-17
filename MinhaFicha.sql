DROP SCHEMA IF EXISTS academico CASCADE;
CREATE SCHEMA academico;

CREATE TABLE academico.pessoas (
    pessoa_id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE academico.professores (
    professor_id INTEGER PRIMARY KEY REFERENCES academico.pessoas(pessoa_id) ON DELETE CASCADE,
    numero_registro VARCHAR(50) UNIQUE NOT NULL,
    departamento VARCHAR(100)
);

CREATE TABLE academico.alunos (
    aluno_id INTEGER PRIMARY KEY REFERENCES academico.pessoas(pessoa_id) ON DELETE CASCADE,
    matricula VARCHAR(50) UNIQUE NOT NULL,
    curso VARCHAR(100) NOT NULL
);

CREATE TABLE academico.disciplinas (
    disciplina_id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    carga_horaria INTEGER,
    periodo VARCHAR(20),
    presenca VARCHAR(255),
    professor_id INTEGER REFERENCES academico.professores(professor_id) ON DELETE SET NULL,
    pre_requisito_id INTEGER REFERENCES academico.disciplinas(disciplina_id) ON DELETE SET NULL
);

CREATE TABLE academico.atividades (
    atividade_id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    data TIMESTAMP, 
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente',

    tipo VARCHAR(50) NOT NULL,
    peso DECIMAL(5, 2),
    recorrencia VARCHAR(50),
    categoria VARCHAR(100),
    disciplina_id INTEGER REFERENCES academico.disciplinas(disciplina_id) ON DELETE CASCADE,
    professor_id INTEGER REFERENCES academico.professores(professor_id) ON DELETE SET NULL
);

CREATE TABLE academico.grades_horarias (
    grade_id SERIAL PRIMARY KEY,
    aluno_id INTEGER UNIQUE NOT NULL REFERENCES academico.alunos(aluno_id) ON DELETE CASCADE
);


CREATE TABLE academico.alunos_disciplinas (
    aluno_id INTEGER NOT NULL REFERENCES academico.alunos(aluno_id) ON DELETE CASCADE,
    disciplina_id INTEGER NOT NULL REFERENCES academico.disciplinas(disciplina_id) ON DELETE CASCADE,
    PRIMARY KEY (aluno_id, disciplina_id)
);

CREATE TABLE academico.alunos_atividades (
    aluno_id INTEGER NOT NULL REFERENCES academico.alunos(aluno_id) ON DELETE CASCADE,
    atividade_id INTEGER NOT NULL REFERENCES academico.atividades(atividade_id) ON DELETE CASCADE,
    status_entrega VARCHAR(50),
    nota DECIMAL(5, 2),
    PRIMARY KEY (aluno_id, atividade_id)
);

CREATE TABLE academico.grades_disciplinas (
    grade_id INTEGER NOT NULL REFERENCES academico.grades_horarias(grade_id) ON DELETE CASCADE,
    disciplina_id INTEGER NOT NULL REFERENCES academico.disciplinas(disciplina_id) ON DELETE CASCADE,
    PRIMARY KEY (grade_id, disciplina_id)
);