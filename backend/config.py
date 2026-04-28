import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

def get_db():
    ssl_disabled = os.getenv("DB_SSL_DISABLED", "false").lower() == "true"
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "127.0.0.1"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", "taashu"),
        database=os.getenv("DB_NAME", "aura_db"),
        port=int(os.getenv("DB_PORT", "3306")),
        use_pure=True,
        ssl_disabled=ssl_disabled
    )