-- tabela dw vendas
create table if not exists dw_vendas(
	pedido_id int,
	data_pedido date,
	data_id text,
	dia int,
	mes int,
	ano int,
	cliente_id int,
	produto_id int,
	produto text,
	categoria text,
	marca text,
	fornecedor text,
	preco_unitario numeric(10, 2),
	quantidade int,
	desconto numeric(12, 2),
	frete numeric(12, 2),
	valor_total numeric(12, 2),
	canal_venda_id int,
	canal_venda text,
	pagamento_id int,
	forma_pagamento text,
	cidade_id int,
	cidade text,
	estado text,
	status_pedido text
);

-- tabela dw estoque
create table if not exists dw_estoque(
	produto_id int,
	produto text,
	categoria text,
	marca text,
	fornecedor text,
	preco_unitario numeric(10, 2),
	estoque_inicial int,
	entradas_periodo int,
	estoque_atual int,
	estoque_minimo int,
	estoque_disponivel int,
	abaixo_minimo boolean,
	local_cd_id int,
	centro_distribuicao text
);

-- tabela dw devolucoes
create table if not exists dw_devolucoes(
	devolucao_id int,
	pedido_id int,
	data_devolucao date,
	data_id text,
	dia int,
	mes int,
	ano int,
	cliente_id int,
	produto_id int,
	produto text,
	categoria text,
	marca text,
	fornecedor text,
	quantidade_devolvida int,
	valor_devolvido numeric(12, 2),
	motivo_devolucao text,
	status_devolucao text
);
