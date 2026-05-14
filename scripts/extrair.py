from pathlib import Path

import pandas as pd

DATA_DIR = Path(__file__).resolve().parents[1] / "data"

ARQUIVOS = {
    "vendas": "vendas.csv",
    "devolucoes": "devolucoes.csv",
    "estoque": "estoque.csv",
}


def extrair() -> dict[str, pd.DataFrame]:
    return {tabela: pd.read_csv(DATA_DIR / arquivo) for tabela, arquivo in ARQUIVOS.items()}


if __name__ == "__main__":
    for tabela, df in extrair().items():
        print(f"{tabela}: {len(df)} linhas, {len(df.columns)} colunas")
