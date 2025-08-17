# MinhaFicha
Este projeto consiste no desenvolvimento de um banco de dados relacional voltado para a gestão acadêmica, com foco nos alunos e professores da Universidade Federal de Ouro Preto (UFOP). O objetivo principal é centralizar e otimizar informações essenciais da vida universitária, como disciplinas, tarefas, notas e controle de presença, em uma plataforma única e eficiente.
O modelo foi projetado para ser uma base robusta para um futuro sistema de gerenciamento escolar, seguindo as melhores práticas de modelagem relacional.

### Modelo ERE Atual
<img width="937" height="483" alt="image" src="https://github.com/user-attachments/assets/75f7b79a-777e-4b32-96e9-1d1c35c48cad" />

### Entidades e Atributos
Pessoa (entidade forte):
Atributos: pessoa_id (pk), CPF, email, nome;

Aluno (entidade forte):
Atributos: aluno_id (pk), matrícula, curso;

Professor (entidade forte):
Atributos: professor_id (pk), numero_registro, departamento;

Disciplina (entidade forte):
Atributos: disciplina_id (pk), Nome, código, pre_requisito, carga_horaria, periodo, presença 

Grade horária (entidade fraca):
atributos: horários;

Atividade (entidade forte):
Atributos: atividade_id, título, descrição, status, data;

Tarefa (entidade fraca):
Atributos: recorrência, categoria;

Atv_avaliativa (entidade fraca):
atributos: peso, ponto_valor (atributo derivado do atributo peso);

### Relacionamentos: 
Professor > *atribui* > Atividade
Professor > *leciona* > Disciplina
Aluno > *cria* (relacionamento fraco) > Grade Horária
Aluno > *executa* > Atividade
Aluno > *matricula_em* > Disciplina
Grade horária > *inclui* > Disciplina
Disciplina > *divulga* > Atividade
