import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

from airflow import DAG
from airflow.operators.python import PythonOperator

from carregar import aplicar_ddl, carregar, get_engine


def _aplicar_ddl() -> None:
    aplicar_ddl(get_engine())


def _carregar() -> None:
    carregar(get_engine())


with DAG(
    dag_id="pipeline_ecommerce",
    description="ETL: CSVs em data/ -> Postgres",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["ecommerce"],
) as dag:
    ddl = PythonOperator(task_id="aplicar_ddl", python_callable=_aplicar_ddl)
    load = PythonOperator(task_id="carregar", python_callable=_carregar)

    ddl >> load
