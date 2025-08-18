INSERT INTO academico.pessoas (pessoa_id, nome, email, cpf) VALUES
(1, 'Beatryz Carneiro', 'beatryz.car@aluno.edu.ufop.com', '111.111.111-11'),
(2, 'Iaggo Lima', 'iaggo.rauta@aluno.ufop.edu.com', '222.222.222-22'),
(3, 'Gabriel Amaro', 'gabriel.amaro@aluno.ufop.edu.com', '333.333.333-33'),
(4, 'Marcos Emiliano', 'marcos.emiliano@ufop.edu.br', '444.444.444-44');

INSERT INTO academico.alunos (aluno_id, matricula, curso) VALUES
(1, '2121234', 'Engenharia de Computação'),
(2, '2015678', 'Sistemas de Informação'),
(3, '2219012', 'Engenharia de Computação');

INSERT INTO academico.professores (professor_id, numero_registro, departamento) VALUES
(4, '98765', 'DECOM');

INSERT INTO academico.disciplinas (disciplina_id, nome, codigo, carga_horaria, periodo, professor_id) VALUES
(101, 'Banco de Dados I', 'CSI440', 60, '4', 4),
(102, 'Estrutura de Dados II', 'BCC202', 60, '3', 4);

INSERT INTO academico.atividades (atividade_id, titulo, descricao, status, data, disciplina_id, professor_id) VALUES
(501, 'Trabalho Prático 1', 'Modelagem e Script SQL', 'Pendente', '2025-09-30', 101, 4);

INSERT INTO academico.atividades (atividade_id, titulo, descricao, status, data, disciplina_id, professor_id) VALUES
(502, 'Revisar SQL', 'Estudar capítulos do livro de Banco de Dados', 'Pendente', '2025-08-25', 102, NULL);


INSERT INTO academico.atividades_avaliativas (atividade_id, peso) VALUES
(501, 25.00);

INSERT INTO academico.tarefas (atividade_id, recorrencia, categoria) VALUES
(502, 'Semanal', 'Estudo');


INSERT INTO academico.alunos_disciplinas (aluno_id, disciplina_id) VALUES
(1, 101),
(2, 101),
(3, 101);

INSERT INTO academico.alunos_atividades (aluno_id, atividade_id) VALUES
(1, 501),
(2, 501),
(3, 501);

INSERT INTO academico.alunos_atividades (aluno_id, atividade_id) VALUES
(2, 502);
