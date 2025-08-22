-- 1. Listar todos os alunos com suas matrículas e cursos
SELECT a.aluno_id, p.nome, a.matricula, a.curso
FROM academico.alunos a
JOIN academico.pessoas p ON p.pessoa_id = a.aluno_id;

-- 2. Listar todas as disciplinas com seus professores responsáveis
SELECT d.disciplina_id, d.nome AS disciplina, pr.nome AS professor
FROM academico.disciplinas d
LEFT JOIN academico.professores pf ON pf.professor_id = d.professor_id
LEFT JOIN academico.pessoas pr ON pr.pessoa_id = pf.professor_id;

-- 3. Consultar todas as atividades atribuídas a um aluno específico
SELECT p.nome AS aluno, a.titulo, a.data, a.status
FROM academico.alunos_atividades aa
JOIN academico.alunos al ON al.aluno_id = aa.aluno_id
JOIN academico.pessoas p ON p.pessoa_id = al.aluno_id
JOIN academico.atividades a ON a.atividade_id = aa.atividade_id
WHERE aa.aluno_id = 1;

-- 4. Consultar apenas as tarefas pendentes de um aluno
SELECT t.atividade_id, a.titulo, a.data, t.categoria
FROM academico.alunos_atividades aa
JOIN academico.atividades a ON a.atividade_id = aa.atividade_id
JOIN academico.tarefas t ON t.atividade_id = a.atividade_id
WHERE aa.aluno_id = 1 AND COALESCE(a.status,'') <> 'concluida';

-- 5. Consultar atividades avaliativas de uma disciplina e seus pesos
SELECT d.nome AS disciplina, a.titulo, av.peso
FROM academico.atividades_avaliativas av
JOIN academico.atividades a ON a.atividade_id = av.atividade_id
JOIN academico.disciplinas d ON d.disciplina_id = a.disciplina_id
WHERE d.codigo = 'BD101';

-- 6. Listar disciplinas de um aluno pela grade horária
SELECT p.nome AS aluno, d.nome AS disciplina, d.periodo
FROM academico.grades_horarias g
JOIN academico.grades_disciplinas gd ON gd.grade_id = g.grade_id
JOIN academico.disciplinas d ON d.disciplina_id = gd.disciplina_id
JOIN academico.alunos al ON al.aluno_id = g.aluno_id
JOIN academico.pessoas p ON p.pessoa_id = al.aluno_id
WHERE g.aluno_id = 1;

-- 7. Relatório de presença por disciplina
SELECT d.nome AS disciplina, r.data_presenca
FROM academico.registros_presenca r
JOIN academico.disciplinas d ON d.disciplina_id = r.disciplina_id
ORDER BY d.nome, r.data_presenca;

-- 8. Calcular pontuação total de um aluno em cada disciplina
SELECT p.nome AS aluno, d.nome AS disciplina,
       SUM(av.peso) AS pontos_totais
FROM academico.alunos_atividades aa
JOIN academico.atividades a ON a.atividade_id = aa.atividade_id
JOIN academico.atividades_avaliativas av ON av.atividade_id = a.atividade_id
JOIN academico.disciplinas d ON d.disciplina_id = a.disciplina_id
JOIN academico.pessoas p ON p.pessoa_id = aa.aluno_id
WHERE aa.aluno_id = 1
GROUP BY p.nome, d.nome;

-- 9. Ver disciplinas que exigem pré-requisito
SELECT d.nome AS disciplina, dp.nome AS pre_requisito
FROM academico.disciplinas d
JOIN academico.disciplinas dp ON dp.disciplina_id = d.pre_requisito_id;
