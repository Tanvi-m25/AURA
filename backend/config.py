import mysql.connector
from dotenv import load_dotenv
import os

# Force load from correct path
load_dotenv(dotenv_path=r"C:\Users\tanvi\AURA\backend\.env")

def get_db():
    return mysql.connector.connect(
        host="127.0.0.1",
        user="root",
        password="taashu",
        database="aura_db",
        port=3306,
        use_pure=True
    )