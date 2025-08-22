DROP SCHEMA IF EXISTS academico CASCADE;
CREATE SCHEMA academico;

CREATE TABLE academico.pessoas (
    pessoa_id SERIAL NOT NULL,
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
    CONSTRAINT fk_alunos_pessoas FOREIGN KEY (aluno_id) REFERENCES academico.pessoas(pessoa_id) ON DELETE CASCADE,
    CONSTRAINT un_alunos_matricula UNIQUE (matricula)
);

CREATE TABLE academico.professores (
    professor_id INTEGER NOT NULL,
    numero_registro VARCHAR(50) NOT NULL,
    departamento VARCHAR(100),
    CONSTRAINT pk_professores PRIMARY KEY (professor_id),
    CONSTRAINT fk_professores_pessoas FOREIGN KEY (professor_id) REFERENCES academico.pessoas(pessoa_id) ON DELETE CASCADE,
    CONSTRAINT un_professores_registro UNIQUE (numero_registro)
);

CREATE TABLE academico.disciplinas (
    disciplina_id SERIAL NOT NULL,
    nome VARCHAR(255) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    carga_horaria INTEGER,
    periodo VARCHAR(20),
    professor_id INTEGER,
    pre_requisito_id INTEGER,
    CONSTRAINT pk_disciplinas PRIMARY KEY (disciplina_id),
    CONSTRAINT un_disciplinas_codigo UNIQUE (codigo)
);

CREATE TABLE academico.atividades (
    atividade_id SERIAL NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descricao VARCHAR(500),
    status VARCHAR(50) DEFAULT 'A FAZER',
    data DATE,

    tipo VARCHAR(20) NOT NULL DEFAULT 'PESSOAL', 
    disciplina_id INTEGER NULL,                  
    professor_id INTEGER NULL,                    
    aluno_criador_id INTEGER NULL,               

    CONSTRAINT pk_atividades PRIMARY KEY (atividade_id)
);

CREATE TABLE academico.alunos_atividades (
    aluno_id INTEGER NOT NULL,
    atividade_id INTEGER NOT NULL,
    CONSTRAINT pk_alunos_atividades PRIMARY KEY (aluno_id, atividade_id)
);


CREATE TABLE academico.grades_horarias (
    grade_id SERIAL NOT NULL,
    aluno_id INTEGER NOT NULL,
    horarios VARCHAR(255),
    CONSTRAINT pk_grades_horarias PRIMARY KEY (grade_id),
    CONSTRAINT fk_grades_alunos FOREIGN KEY (aluno_id) REFERENCES academico.alunos(aluno_id) ON DELETE CASCADE,
    CONSTRAINT un_grades_aluno UNIQUE (aluno_id)
);

CREATE TABLE academico.grades_disciplinas (
    grade_id INTEGER NOT NULL,
    disciplina_id INTEGER NOT NULL,
    CONSTRAINT pk_grades_disciplinas PRIMARY KEY (grade_id, disciplina_id)
);

CREATE TABLE academico.registros_presenca (
    disciplina_id INTEGER NOT NULL,
    data_presenca DATE NOT NULL,
    CONSTRAINT pk_registros_presenca PRIMARY KEY (disciplina_id, data_presenca)
);

CREATE TABLE academico.atividades_avaliativas (
    atividade_id INTEGER NOT NULL,
    peso DECIMAL(5, 2),
    CONSTRAINT pk_atv_avaliativas PRIMARY KEY (atividade_id),
    CONSTRAINT fk_atv_avaliativas_atividades FOREIGN KEY (atividade_id) REFERENCES academico.atividades(atividade_id) ON DELETE CASCADE
);

CREATE TABLE academico.tarefas (
    atividade_id INTEGER NOT NULL,
    recorrencia VARCHAR(50),
    categoria VARCHAR(100),
    CONSTRAINT pk_tarefas PRIMARY KEY (atividade_id),
    CONSTRAINT fk_tarefas_atividades FOREIGN KEY (atividade_id) REFERENCES academico.atividades(atividade_id) ON DELETE CASCADE
);


ALTER TABLE academico.disciplinas ADD CONSTRAINT fk_disciplinas_professores
FOREIGN KEY (professor_id) REFERENCES academico.professores(professor_id) ON DELETE SET NULL;

ALTER TABLE academico.disciplinas ADD CONSTRAINT fk_disciplinas_prerequisito
FOREIGN KEY (pre_requisito_id) REFERENCES academico.disciplinas(disciplina_id) ON DELETE SET NULL;

ALTER TABLE academico.grades_disciplinas ADD CONSTRAINT fk_gd_grade
FOREIGN KEY (grade_id) REFERENCES academico.grades_horarias(grade_id) ON DELETE CASCADE;

ALTER TABLE academico.grades_disciplinas ADD CONSTRAINT fk_gd_disciplina
FOREIGN KEY (disciplina_id) REFERENCES academico.disciplinas(disciplina_id) ON DELETE CASCADE;

ALTER TABLE academico.registros_presenca ADD CONSTRAINT fk_presenca_disciplina
FOREIGN KEY (disciplina_id) REFERENCES academico.disciplinas(disciplina_id) ON DELETE CASCADE;

ALTER TABLE academico.atividades ADD CONSTRAINT fk_atividades_disciplinas
FOREIGN KEY (disciplina_id) REFERENCES academico.disciplinas(disciplina_id) ON DELETE CASCADE;

ALTER TABLE academico.atividades ADD CONSTRAINT fk_atividades_professores
FOREIGN KEY (professor_id) REFERENCES academico.professores(professor_id) ON DELETE SET NULL;

ALTER TABLE academico.atividades ADD CONSTRAINT fk_atividades_aluno_criador
FOREIGN KEY (aluno_criador_id) REFERENCES academico.alunos(aluno_id) ON DELETE SET NULL;


ALTER TABLE academico.alunos_atividades ADD CONSTRAINT fk_aa_aluno
FOREIGN KEY (aluno_id) REFERENCES academico.alunos(aluno_id) ON DELETE CASCADE;

ALTER TABLE academico.alunos_atividades ADD CONSTRAINT fk_aa_atividade
FOREIGN KEY (atividade_id) REFERENCES academico.atividades(atividade_id) ON DELETE CASCADE;
