-- Limpando tabelas de consumo antes da carga
TRUNCATE TABLE
	dw_devolucoes,
	dw_estoque,
	dw_vendas;

-- Inserindo dados na tabela dw_vendas
INSERT INTO dw_vendas(
	pedido_id, data_pedido, data_id, dia, mes, ano,
	cliente_id, produto_id, produto, categoria, marca, fornecedor,
	preco_unitario, quantidade, desconto, frete, valor_total,
	canal_venda_id, canal_venda, pagamento_id, forma_pagamento,
	cidade_id, cidade, estado, status_pedido
)
select
	v.pedido_id,
	v.data_pedido,
	t.data_id,
	t.dia,
	t.mes,
	t.ano,
	v.cliente_id,
	p.produto_id,
	p.produto,
	p.categoria,
	p.marca,
	p.fornecedor,
	p.preco_unitario,
	v.quantidade,
	v.desconto,
	v.frete,
	v.valor_total,
	cv.canal_venda_id,
	cv.canal_venda,
	pg.pagamento_id,
	pg.forma_pagamento,
	cd.cidade_id,
	cd.cidade,
	cd.estado,
	v.status_pedido
from stg_fact_vendas as v
left join stg_dim_produtos as p
	on p.produto_id = v.produto_id
left join stg_dim_canal_vendas as cv
	on cv.canal_venda_id = v.canal_venda_id
left join stg_dim_pagamento as pg
	on pg.pagamento_id = v.pagamento_id
left join stg_dim_cidade as cd
	on cd.cidade_id = v.cidade_id
left join stg_dim_tempo as t
	on t.data = v.data_pedido;

select * from dw_vendas;

-- Inserindo dados na tabela dw_estoque
INSERT INTO dw_estoque(
	produto_id, produto, categoria, marca, fornecedor, preco_unitario,
	estoque_inicial, entradas_periodo, estoque_atual, estoque_minimo,
	estoque_disponivel, abaixo_minimo, local_cd_id, centro_distribuicao
)
select
	p.produto_id,
	p.produto,
	p.categoria,
	p.marca,
	p.fornecedor,
	p.preco_unitario,
	e.estoque_inicial,
	e.entradas_periodo,
	e.estoque_atual,
	e.estoque_minimo,
	(e.estoque_atual - e.estoque_minimo) as estoque_disponivel,
	(e.estoque_atual < e.estoque_minimo) as abaixo_minimo,
	l.local_cd_id,
	l.centro_distribuicao
from stg_fact_estoque as e
left join stg_dim_produtos as p
	on p.produto_id = e.produto_id
left join stg_dim_localidade as l
	on l.local_cd_id = e.local_cd_id;

select * from dw_estoque;

-- Inserindo dados na tabela dw_devolucoes
INSERT INTO dw_devolucoes(
	devolucao_id, pedido_id, data_devolucao, data_id, dia, mes, ano,
	cliente_id, produto_id, produto, categoria, marca, fornecedor,
	quantidade_devolvida, valor_devolvido, motivo_devolucao, status_devolucao
)
select
	d.devolucao_id,
	d.pedido_id,
	t.data as data_devolucao,
	t.data_id,
	t.dia,
	t.mes,
	t.ano,
	d.cliente_id,
	p.produto_id,
	p.produto,
	p.categoria,
	p.marca,
	p.fornecedor,
	d.quantidade_devolvida,
	d.valor_devolvido,
	d.motivo_devolucao,
	d.status_devolucao
from stg_fact_devolucoes as d
left join stg_dim_produtos as p
	on p.produto_id = d.produto_id
left join stg_dim_tempo as t
	on t.data = d.data_devolucao;

select * from dw_devolucoes;

