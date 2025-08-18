import psycopg2

def get_connection():
    conn = psycopg2.connect(
        dbname="MinhaFichaTeste",
        user="postgres",
        password="password",
        host="localhost",
        port="5432"
    )
    return conn