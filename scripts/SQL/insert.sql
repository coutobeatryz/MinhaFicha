-- Pessoas (5 alunos + 3 professores)
INSERT INTO academico.pessoas (cpf, email, nome) VALUES
('111.111.111-11', 'gabriel.fonseca@ufop.edu.br', 'Gabriel Fonseca'),
('222.222.222-22', 'victor.cssiano@ufop.edu.br', 'Victor Cassiano'),
('333.333.333-33', 'iaggo.rauta@ufop.edu.br', 'Iaggo Rauta'),
('444.444.444-44', 'beatryz.car@ufop.edu.br', 'Beatryz Couto'),
('555.555.555-55', 'lucas.oliveira@email.com', 'Lucas Oliveira'),

('666.666.666-66', 'prof.jose@email.com', 'Prof. José Almeida'),
('777.777.777-77', 'prof.clara@email.com', 'Profa. Clara Mendes'),
('888.888.888-88', 'prof.paulo@email.com', 'Prof. Paulo Andrade');

-- Alunos (pessoa_id de 1 a 5)
INSERT INTO academico.alunos (aluno_id, matricula, curso) VALUES
(1, '2025001', 'Engenharia Elétrica'),
(2, '2025002', 'Ciência da Computação'),
(3, '2025003', 'Administração'),
(4, '2025004', 'Engenharia de Computação'),
(5, '2025005', 'Direito');

-- Professores (pessoa_id de 6 a 8)
INSERT INTO academico.professores (professor_id, numero_registro, departamento) VALUES
(6, 'P001', 'Departamento de Exatas'),
(7, 'P002', 'Departamento de Humanas'),
(8, 'P003', 'Departamento de Direito');

-- Grades Horárias (1 grade por aluno)
INSERT INTO academico.grades_horarias (aluno_id, horarios) VALUES
(1, 'Seg-Qua-Sex 08:00-10:00'),
(2, 'Ter-Qua-Qui 14:00-16:00'),
(3, 'Seg-Ter-Qua 10:00-12:00'),
(4, 'Qua-Sex 18:00-20:00'),
(5, 'Seg-Qui 19:00-21:00');

-- Disciplinas
INSERT INTO academico.disciplinas (nome, codigo, carga_horaria, periodo, professor_id, pre_requisito_id) VALUES
('Cálculo I', 'MAT101', 60, '1º', 6, NULL),
('Algoritmos', 'COMP101', 60, '1º', 6, NULL),
('Introdução ao Direito', 'DIR101', 60, '1º', 8, NULL),
('Administração Geral', 'ADM101', 60, '1º', 7, NULL),
('Estruturas de Dados', 'COMP201', 60, '2º', 6, 2);

-- Grades Disciplinas (vincula alunos a disciplinas)
INSERT INTO academico.grades_disciplinas (grade_id, disciplina_id) VALUES
(1, 1), (1, 2),
(2, 2), (2, 5),
(3, 4),
(4, 1),
(5, 3);

-- Registros de presença
INSERT INTO academico.registros_presenca (disciplina_id, data_presenca) VALUES
(1, '2025-08-01'),
(1, '2025-08-08'),
(2, '2025-08-02'),
(3, '2025-08-03'),
(5, '2025-08-04');

-- Atividades
INSERT INTO academico.atividades (titulo, descricao, status, data, disciplina_id, professor_id) VALUES
('Lista de Exercícios 1', 'Exercícios sobre derivadas', 'Aberta', '2025-08-10', 1, 6),
('Trabalho de Algoritmos', 'Implementar um algoritmo de ordenação', 'Aberta', '2025-08-12', 2, 6),
('Seminário de Direito', 'Apresentação sobre Constituição Federal', 'Aberta', '2025-08-15', 3, 8),
('Prova ADM I', 'Primeira avaliação de Administração Geral', 'Pendente', '2025-08-20', 4, 7);

-- Atividades Avaliativas
INSERT INTO academico.atividades_avaliativas (atividade_id, peso) VALUES
(1, 2.0),
(2, 3.0),
(3, 2.5),
(4, 4.0);

-- Tarefas
INSERT INTO academico.tarefas (atividade_id, recorrencia, categoria) VALUES
(1, 'Semanal', 'Exercícios'),
(2, 'Única', 'Projeto'),
(3, 'Única', 'Seminário'),
(4, 'Única', 'Prova');

-- Alunos em atividades
INSERT INTO academico.alunos_atividades (aluno_id, atividade_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 4),
(5, 3);
