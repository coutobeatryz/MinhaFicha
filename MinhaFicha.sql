DROP SCHEMA academico CASCADE;
CREATE SCHEMA academico;


CREATE TABLE academico.pessoas (
    pessoa_id INTEGER NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    email VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    CONSTRAINT pk_pessoas PRIMARY KEY (pessoa_id),
    CONSTRAINT un_pessoas_cpf UNIQUE (cpf),
    CONSTRAINT un_pessoas_email UNIQUE (email)
);

CREATE TABLE academico.alunos (
    aluno_id INTEGER NOT NULL,
    matricula VARCHAR(50) NOT NULL,
    curso VARCHAR(100) NOT NULL,
    CONSTRAINT pk_alunos PRIMARY KEY (aluno_id),
    CONSTRAINT fk_alunos_pessoas FOREIGN KEY (aluno_id) REFERENCES academico.pessoas(pessoa_id),
    CONSTRAINT un_alunos_matricula UNIQUE (matricula)
);

CREATE TABLE academico.professores (
    professor_id INTEGER NOT NULL,
    numero_registro VARCHAR(50) NOT NULL,
    departamento VARCHAR(100),
    CONSTRAINT pk_professores PRIMARY KEY (professor_id),
    CONSTRAINT fk_professores_pessoas FOREIGN KEY (professor_id) REFERENCES academico.pessoas(pessoa_id),
    CONSTRAINT un_professores_registro UNIQUE (numero_registro)
);

CREATE TABLE academico.grades_horarias (
    aluno_id INTEGER NOT NULL,
    horarios VARCHAR(255),
    CONSTRAINT pk_grades_horarias PRIMARY KEY (aluno_id),
    CONSTRAINT fk_grades_alunos FOREIGN KEY (aluno_id) REFERENCES academico.alunos(aluno_id)
);

CREATE TABLE academico.disciplinas (
    disciplina_id INTEGER NOT NULL,
    nome VARCHAR(255) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    carga_horaria INTEGER,
    periodo VARCHAR(20),
    presenca VARCHAR(255),
    professor_id INTEGER,
    pre_requisito_id INTEGER,
    CONSTRAINT pk_disciplinas PRIMARY KEY (disciplina_id),
    CONSTRAINT un_disciplinas_codigo UNIQUE (codigo)
);

CREATE TABLE academico.atividades (
    atividade_id INTEGER NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descricao VARCHAR(500),
    status VARCHAR(50),
    data DATE,
    disciplina_id INTEGER,
    CONSTRAINT pk_atividades PRIMARY KEY (atividade_id)
);

CREATE TABLE academico.atividades_avaliativas (
    atividade_id INTEGER NOT NULL,
    peso DECIMAL(5, 2),
    CONSTRAINT pk_atv_avaliativas PRIMARY KEY (atividade_id),
    CONSTRAINT fk_atv_avaliativas_atividades FOREIGN KEY (atividade_id) REFERENCES academico.atividades(atividade_id)
);

CREATE TABLE academico.tarefas (
    atividade_id INTEGER NOT NULL,
    recorrencia VARCHAR(50),
    categoria VARCHAR(100),
    CONSTRAINT pk_tarefas PRIMARY KEY (atividade_id),
    CONSTRAINT fk_tarefas_atividades FOREIGN KEY (atividade_id) REFERENCES academico.atividades(atividade_id)
);

CREATE TABLE academico.alunos_disciplinas (
    aluno_id INTEGER NOT NULL,
    disciplina_id INTEGER NOT NULL,
    CONSTRAINT pk_alunos_disciplinas PRIMARY KEY (aluno_id, disciplina_id)
);

CREATE TABLE academico.alunos_atividades (
    aluno_id INTEGER NOT NULL,
    atividade_id INTEGER NOT NULL,
    CONSTRAINT pk_alunos_atividades PRIMARY KEY (aluno_id, atividade_id)
);

CREATE TABLE academico.grades_disciplinas (
    grade_id INTEGER NOT NULL,
    disciplina_id INTEGER NOT NULL,
    CONSTRAINT pk_grades_disciplinas PRIMARY KEY (grade_id, disciplina_id)
);

ALTER TABLE academico.disciplinas ADD CONSTRAINT fk_disciplinas_professores
FOREIGN KEY (professor_id) REFERENCES academico.professores(professor_id);

ALTER TABLE academico.disciplinas ADD CONSTRAINT fk_disciplinas_prerequisito
FOREIGN KEY (pre_requisito_id) REFERENCES academico.disciplinas(disciplina_id);

ALTER TABLE academico.atividades ADD CONSTRAINT fk_atividades_disciplinas
FOREIGN KEY (disciplina_id) REFERENCES academico.disciplinas(disciplina_id);

ALTER TABLE academico.atividades ADD COLUMN professor_id INTEGER;
ALTER TABLE academico.atividades ADD CONSTRAINT fk_atividades_professores
FOREIGN KEY (professor_id) REFERENCES academico.professores(professor_id);

ALTER TABLE academico.alunos_disciplinas ADD CONSTRAINT fk_ad_aluno
FOREIGN KEY (aluno_id) REFERENCES academico.alunos(aluno_id);
ALTER TABLE academico.alunos_disciplinas ADD CONSTRAINT fk_ad_disciplina
FOREIGN KEY (disciplina_id) REFERENCES academico.disciplinas(disciplina_id);

ALTER TABLE academico.alunos_atividades ADD CONSTRAINT fk_aa_aluno
FOREIGN KEY (aluno_id) REFERENCES academico.alunos(aluno_id);
ALTER TABLE academico.alunos_atividades ADD CONSTRAINT fk_aa_atividade
FOREIGN KEY (atividade_id) REFERENCES academico.atividades(atividade_id);

ALTER TABLE academico.grades_disciplinas ADD CONSTRAINT fk_gd_grade
FOREIGN KEY (grade_id) REFERENCES academico.grades_horarias(aluno_id);
ALTER TABLE academico.grades_disciplinas ADD CONSTRAINT fk_gd_disciplina
FOREIGN KEY (disciplina_id) REFERENCES academico.disciplinas(disciplina_id);
