import psycopg2

def get_connection():
    conn = psycopg2.connect(
        dbname="MinhaFicha",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )
    return conn