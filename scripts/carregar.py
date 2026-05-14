import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

from extrair import extrair

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "sql"

load_dotenv(ROOT / "config" / ".env")


def get_engine() -> Engine:
    user = os.environ["USER_POSTGRES"]
    password = os.environ["PASSWORD_POSTGRES"]
    host = os.environ["HOST_POSTGRES"]
    port = os.environ["PORT_POSTGRES"]
    database = os.environ["DATABASE_POSTGRES"]
    return create_engine(
        f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    )


def aplicar_ddl(engine: Engine) -> None:
    with engine.begin() as conn:
        for arquivo in sorted(SQL_DIR.glob("*.sql")):
            conn.execute(text(arquivo.read_text()))


def carregar(engine: Engine) -> None:
    dados = extrair()
    with engine.begin() as conn:
        for tabela, df in dados.items():
            conn.execute(text(f"TRUNCATE TABLE {tabela}"))
            df.to_sql(tabela, conn, if_exists="append", index=False)
            print(f"{tabela}: {len(df)} linhas carregadas")


if __name__ == "__main__":
    engine = get_engine()
    aplicar_ddl(engine)
    carregar(engine)
