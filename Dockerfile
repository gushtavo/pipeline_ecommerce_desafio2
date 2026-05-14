FROM apache/airflow:2.10.2-python3.12

USER airflow

RUN pip install --no-cache-dir \
    psycopg2-binary \
    python-dotenv
