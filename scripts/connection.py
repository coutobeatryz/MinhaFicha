import psycopg2

def get_connection():
    conn = psycopg2.connect(
        dbname="MinhaFicha", #Nome do server
        user="postgres",
        password="1234", #Senha que você escolheu
        host="localhost",
        port="5432"
    )

    return conn
