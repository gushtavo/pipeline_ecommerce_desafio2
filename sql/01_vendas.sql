CREATE TABLE IF NOT EXISTS vendas (
    pedido_id        INTEGER,
    data_pedido      DATE,
    cliente_id       INTEGER,
    produto_id       INTEGER,
    produto          TEXT,
    categoria        TEXT,
    marca            TEXT,
    quantidade       INTEGER,
    preco_unitario   NUMERIC(12, 2),
    desconto         NUMERIC(12, 2),
    frete            NUMERIC(12, 2),
    valor_total      NUMERIC(12, 2),
    canal_venda      TEXT,
    forma_pagamento  TEXT,
    cidade           TEXT,
    estado           CHAR(2),
    status_pedido    TEXT
);
