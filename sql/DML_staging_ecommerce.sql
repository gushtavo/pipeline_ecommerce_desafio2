-- Limpando as tabelas de staging antes da carga
TRUNCATE TABLE
	stg_fact_devolucoes,
	stg_fact_estoque,
	stg_fact_vendas,
	stg_dim_produtos,
	stg_dim_cliente,
	stg_dim_cidade,
	stg_dim_tempo,
	stg_dim_localidade,
	stg_dim_canal_vendas,
	stg_dim_pagamento
RESTART IDENTITY CASCADE;

-- Inserindo dados na tabela produtos
INSERT INTO stg_dim_produtos (produto_id, produto, categoria, preco_unitario, marca, fornecedor)
	select distinct
		e.produto_id,
		e.produto,
		e.categoria,
		e.custo_unitario,
		e.marca,
		e.fornecedor
	from estoque as e;

select * from stg_dim_produtos;

-- Inserindo dados na tabela clientes
INSERT INTO stg_dim_cliente (cliente_id)
	select
		distinct cliente_id
	from vendas as v
	order by cliente_id;

select * from stg_dim_cliente;

--inserindo dados tabela cidade
INSERT INTO stg_dim_cidade(cidade, estado)
	select 
		distinct cidade,
		estado
	from vendas;

select * from stg_dim_cidade;

-- Inserindo dados na tabela tempo
INSERT INTO stg_dim_tempo(data_id, data, dia, mes, ano)
select distinct
	to_char(d, 'yyyymmdd') as data_id,
	d as data,
	extract(day from d) as dia,
	extract(month from d) as mes,
	extract(year from d) as ano
from (select data_pedido as d from vendas
		union all
		select data_devolucao from devolucoes);

select * from stg_dim_tempo;

-- Inserindo dados na tabela Localidade
INSERT INTO stg_dim_localidade (centro_distribuicao)
SELECT distinct e.centro_distribuicao
from estoque as e;

select * from stg_dim_localidade;

--Inserindo dados na tabela canal de venda
INSERT INTO stg_dim_canal_vendas (canal_venda)
select
 	distinct canal_venda
from vendas as v;

select * from stg_dim_canal_vendas;

-- Inserindo dados na tabela pagamento
INSERT INTO stg_dim_pagamento (forma_pagamento)
select
	distinct forma_pagamento
from vendas as v;

select * from stg_dim_pagamento;

--Inserindo dados tabela vendas
INSERT INTO stg_fact_vendas(pedido_id, data_pedido, cliente_id, produto_id, 
quantidade, desconto, frete, valor_total, canal_venda_id, pagamento_id, cidade_id, status_pedido)
select
	v.pedido_id,
	v.data_pedido,
	c.cliente_id,
	p.produto_id,
	v.quantidade,
	v.desconto,
	v.frete,
	(p.preco_unitario * v.quantidade - v.desconto) + v.frete as valor_total, -- corrige o cálculo do valor total conforme desconto e frete
	cv.canal_venda_id,
	pg.pagamento_id,
	cd.cidade_id,
	v.status_pedido
from vendas as v
left join stg_dim_cliente as c
	on c.cliente_id = v.cliente_id
left join stg_dim_pagamento as pg
	on pg.forma_pagamento = v.forma_pagamento
left join stg_dim_canal_vendas as cv
	on cv.canal_venda = v.canal_venda
left join stg_dim_cidade as cd
	on cd.cidade = v.cidade
left join stg_dim_produtos as p
	on p.produto_id = v.produto_id;

select * from stg_fact_vendas;

-- inserindo dados tabela estoque
INSERT INTO stg_fact_estoque (produto_id, estoque_inicial, estoque_minimo, estoque_atual, entradas_periodo, local_cd_id)
select
	p.produto_id,
	e.estoque_inicial,
	e.estoque_minimo,
	e.estoque_atual,
	e.entradas_periodo,
	l.local_cd_id
from estoque as e
left join stg_dim_produtos as p
	on p.produto_id = e.produto_id
left join stg_dim_localidade as l
	on l.centro_distribuicao = e.centro_distribuicao;

select * from stg_fact_estoque;

-- Inserindo dados na tabela estoque
INSERT INTO stg_fact_devolucoes(devolucao_id, pedido_id, data_devolucao, cliente_id, produto_id, quantidade_devolvida, 
	valor_devolvido, motivo_devolucao, status_devolucao)
	select
		d.devolucao_id,
		v.pedido_id,
		d.data_devolucao,
		c.cliente_id,
		p.produto_id,
		d.quantidade_devolvida,
		(p.preco_unitario * d.quantidade_devolvida) as valor_devolvido, -- normalizando valor devolvido
		d.motivo_devolucao,
		d.status_devolucao
	from devolucoes as d
	left join stg_fact_vendas as v
		on v.pedido_id = d.pedido_id
	left join stg_dim_cliente as c
		on c.cliente_id = d.cliente_id
	left join stg_dim_produtos as p
		on p.produto_id = d.produto_id;

select * from stg_fact_devolucoes;
