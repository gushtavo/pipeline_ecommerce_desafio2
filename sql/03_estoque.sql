CREATE TABLE IF NOT EXISTS estoque (
    produto_id           INTEGER,
    produto              TEXT,
    categoria            TEXT,
    marca                TEXT,
    fornecedor           TEXT,
    estoque_inicial      INTEGER,
    entradas_periodo     INTEGER,
    estoque_atual        INTEGER,
    estoque_minimo       INTEGER,
    custo_unitario       NUMERIC(12, 2),
    centro_distribuicao  TEXT
);
