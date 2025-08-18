## 🚀 Guia de Execução da Aplicação

Siga os passos abaixo para configurar e executar o projeto em seu ambiente local.

### ✅ 1. Pré-requisitos

Antes de começar, garanta que você tenha os seguintes softwares instalados:
* **Python 3.x** e **pip**
* **Git**
* **PostgreSQL** (o serviço do banco de dados deve estar instalado e rodando)

### ⚙️ 2. Configuração do Ambiente
Clone o repositório do GitHub
```bash
git clone [https://github.com/coutobeatryz/MinhaFicha.git](https://github.com/coutobeatryz/MinhaFicha.git)
```
Acesse a pasta do projeto
```bash
cd MinhaFicha
```
### 🗄️ 3. Configuração do Banco de Dados

Esta é a etapa mais importante. Você precisa criar o banco de dados e as tabelas do projeto.

1.  **Crie um banco de dados no PostgreSQL.** Você pode usar o nome que preferir, por exemplo: `minhaficha_db`.
2.  **Execute o script `banco.sql`** que está no repositório para criar todas as tabelas. Você pode fazer isso via linha de comando (`psql`) ou por uma ferramenta gráfica (DBeaver, pgAdmin).

    * *Exemplo usando `psql` no terminal:*
        ```bash
        psql -U seu_usuario_postgres -d minhaficha_db -f banco.sql
        ```

3.  **Ajuste a conexão no código:**
    * Abra o arquivo `app.py`.
    * Localize a função `get_db_connection()` e a linha `psycopg2.connect(...)`.
    * **Altere os dados** (`dbname`, `user`, `password`, `host`) para que correspondam à configuração do seu banco de dados local.

    ```python
    # Exemplo da linha a ser alterada em app.py
    conn = psycopg2.connect(
        dbname="minhaficha_db",  # O nome que você deu ao seu banco
        user="seu_usuario",      # Seu usuário do PostgreSQL
        password="sua_senha",    # Sua senha do PostgreSQL
        host="localhost"
    )
    ```

### ▶️ 4. Execute a Aplicação

Com tudo configurado, inicie o servidor Flask.

```bash
# No terminal, com o ambiente virtual (venv) ativo, execute:
python app.py
