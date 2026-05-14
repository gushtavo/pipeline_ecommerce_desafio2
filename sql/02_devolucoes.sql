CREATE TABLE IF NOT EXISTS devolucoes (
    devolucao_id          INTEGER,
    pedido_id             INTEGER,
    data_devolucao        DATE,
    cliente_id            INTEGER,
    produto_id            INTEGER,
    quantidade_devolvida  INTEGER,
    valor_devolvido       NUMERIC(12, 2),
    motivo_devolucao      TEXT,
    status_devolucao      TEXT
);
