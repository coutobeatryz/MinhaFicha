## 📝 Sobre o Projeto

Este projeto foi desenvolvido como trabalho acadêmico para a disciplina de **Banco de Dados**, ministrada pelo professor **Marcos Emiliano**, na **Universidade Federal de Ouro Preto (UFOP)**.

O objetivo do **MinhaFicha** é desenvolver um banco de dados relacional robusto para a gestão de informações da vida universitária. A plataforma busca centralizar e otimizar dados essenciais como disciplinas, atividades, notas e controle de presença, servindo como uma base sólida para um futuro sistema de gerenciamento escolar.

## 🧑‍💻 Integrantes do Grupo

* Beatryz Aparecida do Couto Medeiros de Freitas Carneiro
* Iaggo Rauta Ramos de Lima
* Gabriel Fonseca Amaro

## 📊 Diagrama Entidade-Relacionamento (E-R)

O modelo conceitual abaixo representa a estrutura do banco de dados, mostrando as entidades e como elas se relacionam.

<img width="923" height="473" alt="image" src="https://github.com/user-attachments/assets/bc979364-206e-4859-a6d0-2fa7b73fb643" />


## 🏗️ Estrutura do Banco de Dados

### Entidades e Atributos

A seguir estão detalhadas as entidades do modelo e seus respectivos atributos.

* **Pessoa** (Entidade Forte)
    * `pessoa_id` (PK)
    * `CPF`
    * `email`
    * `nome`

* **Aluno** (Entidade Forte, especialização de Pessoa)
    * `aluno_id` (PK)
    * `matricula`
    * `curso`

* **Professor** (Entidade Forte, especialização de Pessoa)
    * `professor_id` (PK)
    * `numero_registro`
    * `departamento`

* **Disciplina** (Entidade Forte)
    * `disciplina_id` (PK)
    * `nome`
    * `codigo`
    * `pre_requisito`
    * `carga_horaria`
    * `periodo`
    * `presenca` (Atributo multivalorado)

* **Grade Horária** (Entidade Fraca, dependente de Aluno)
    * `horarios`

* **Atividade** (Entidade Forte)
    * `atividade_id` (PK)
    * `titulo`
    * `descricao`
    * `status`
    * `data`

* **Tarefa** (Entidade Forte, especialização de Atividade)
    * `recorrencia`
    * `categoria`

* **Atividade Avaliativa** (Entidade Forte, especialização de Atividade)
    * `peso`
    * `ponto_valor` (Atributo derivado do atributo `peso`)

### Relacionamentos

* **Professor** _leciona_ **Disciplina**
* **Professor** _atribui_ **Atividade**
* **Aluno** _executa_ **Atividade**
* **Aluno** _cria_ **Grade Horária** (Relacionamento fraco)
* **Disciplina** _é incluída em_ **Grade Horária**
* **Disciplina** _divulga_ **Atividade**

---
