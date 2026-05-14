select * from dw_vendas;

-- faturamento por mes
SELECT
	ano,
	mes,
	sum(valor_total) as total_faturamento
FROM dw_vendas 
group by ano, mes
order by ano, mes;

-- faturamento por produto
SELECT
	produto,
	sum(valor_total) as total_faturamento
FROM dw_vendas 
group by produto
order by total_faturamento desc;

-- faturamento por categoria
SELECT
	categoria,
	sum(valor_total) as total_faturamento
FROM dw_vendas 
group by categoria
order by total_faturamento desc;

-- faturamento por estado
SELECT
	estado,
	sum(valor_total) as total_faturamento
FROM dw_vendas 
group by estado
order by total_faturamento desc;

-- quantidade de vendas por canal de venda
SELECT
	canal_venda,
	count(*) as qtd_vendas
FROM dw_vendas
group by canal_venda
order by qtd_vendas desc;

-- quantidade de vendas por forma de pagamento
SELECT
	forma_pagamento,
	count(*) as qtd_vendas
FROM dw_vendas
group by forma_pagamento
order by qtd_vendas desc;

-- Porcentagem de Devolucao em Geral
select
	count(v.pedido_id) as total_vendas,
	count(d.devolucao_id) as total_devolucoes,
	round(
			(count(d.devolucao_id)::numeric / count(v.pedido_id)),
			2) * 100 as perct_devolucoes
from dw_vendas as v
left join dw_devolucoes as d
	on d.pedido_id = v.pedido_id
;

-- Porcetagem de Devoluções com Status de Concluída
with vendas as (
	select
		pedido_id
	from dw_vendas
),
devolucoes as (
	select
		pedido_id,
		devolucao_id
	from dw_devolucoes
	where status_devolucao = 'Concluída'
)
select
	count(v.pedido_id) as total_vendas,
	count(d.devolucao_id) as total_devolucoes,
	round(
			(count(d.devolucao_id)::numeric / count(v.pedido_id)),
			2) * 100 as perct_devolucoes
from vendas as v
left join devolucoes as d
	on d.pedido_id = v.pedido_id;

-- Valor Perdido com devolucoes
select
	ano,
	mes,
	sum(valor_devolvido) as total_devolvido
from dw_devolucoes
group by ano, mes
order by ano, mes;

-- Faturamento liquido
select
	sum(v.valor_total) as faturamento_bruto,
	sum(d.valor_devolvido) as total_devolucao,
	sum(v.valor_total) - sum(d.valor_devolvido) as faturamento_liquido
from dw_vendas as v
left join dw_devolucoes as d
	on d.pedido_id = v.pedido_id;

-- Produtos abaixo do estoque minimo
select
	produto_id,
	produto,
	estoque_atual,
	estoque_minimo
from dw_estoque
where estoque_atual < estoque_minimo;

select * from dw_estoque;