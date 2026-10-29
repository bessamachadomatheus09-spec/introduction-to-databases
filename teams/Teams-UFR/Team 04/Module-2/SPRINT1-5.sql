-- ============================================================
-- SPRINT1-5.sql
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS
-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_mercado
-- Tema: Banco de dados de mercado
-- SGBD: MySQL
-- ============================================================

USE db_mercado;

-- 1. INNER JOIN
-- Pergunta: Quais vendas foram realizadas, por quais clientes e funcionários?
SELECT
    v.id_venda,
    c.nome AS cliente,
    f.nome AS funcionario,
    v.data_venda,
    v.status
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
INNER JOIN funcionario AS f
    ON f.id_funcionario = v.id_funcionario
ORDER BY v.id_venda;

-- 2. INNER JOIN
-- Pergunta: Quais produtos aparecem em cada venda e em qual quantidade?
SELECT
    v.id_venda,
    p.nome AS produto,
    iv.quantidade,
    iv.preco_unitario,
    ROUND(iv.quantidade * iv.preco_unitario, 2) AS subtotal
FROM item_venda AS iv
INNER JOIN venda AS v
    ON v.id_venda = iv.id_venda
INNER JOIN produto AS p
    ON p.id_produto = iv.id_produto
ORDER BY v.id_venda, p.nome;

-- 3. LEFT JOIN
-- Pergunta: Quantas vendas cada cliente possui, inclusive clientes sem venda?
SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(v.id_venda) AS quantidade_vendas
FROM cliente AS c
LEFT JOIN venda AS v
    ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_vendas DESC, c.nome;

-- 4. RIGHT JOIN
-- Pergunta: Quais produtos estão cadastrados e quais itens de venda estão ligados a eles?
-- O RIGHT JOIN mantém todos os produtos da tabela à direita.
SELECT
    p.id_produto,
    p.nome AS produto,
    iv.id_item_venda,
    iv.id_venda,
    iv.quantidade
FROM item_venda AS iv
RIGHT JOIN produto AS p
    ON p.id_produto = iv.id_produto
ORDER BY p.nome;

-- 5. JOIN COM TRÊS OU MAIS TABELAS
-- Pergunta: Quais clientes compraram quais produtos em cada venda?
SELECT
    v.id_venda,
    c.nome AS cliente,
    p.nome AS produto,
    iv.quantidade,
    ROUND(iv.quantidade * iv.preco_unitario, 2) AS subtotal
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
INNER JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
INNER JOIN produto AS p
    ON p.id_produto = iv.id_produto
ORDER BY v.id_venda, p.nome;

-- 6. JOIN COM TRÊS OU MAIS TABELAS
-- Pergunta: Qual funcionário atendeu cada venda e qual foi o valor dos itens?
SELECT
    v.id_venda,
    f.nome AS funcionario,
    c.nome AS cliente,
    v.status,
    ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS total_venda
FROM venda AS v
INNER JOIN funcionario AS f
    ON f.id_funcionario = v.id_funcionario
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
INNER JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
GROUP BY v.id_venda, f.nome, c.nome, v.status
ORDER BY v.id_venda;

-- 7. JOIN + WHERE
-- Pergunta: Quais vendas foram finalizadas e quem foram os clientes?
SELECT
    v.id_venda,
    c.nome AS cliente,
    v.data_venda,
    v.status
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
WHERE v.status = 'finalizada'
ORDER BY v.data_venda;

-- 8. JOIN + ORDER BY
-- Pergunta: Quais produtos tiveram o maior valor de subtotal nos itens vendidos?
SELECT
    p.nome AS produto,
    iv.id_venda,
    iv.quantidade,
    iv.preco_unitario,
    ROUND(iv.quantidade * iv.preco_unitario, 2) AS subtotal
FROM item_venda AS iv
INNER JOIN produto AS p
    ON p.id_produto = iv.id_produto
ORDER BY subtotal DESC;

-- Pergunta: Qual foi o total vendido em cada venda?
SELECT
    v.id_venda,
    c.nome AS cliente,
    COUNT(iv.id_item_venda) AS quantidade_de_itens,
    ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS total_venda,
    AVG(iv.preco_unitario) AS preco_medio_dos_itens,
    MIN(iv.preco_unitario) AS menor_preco,
    MAX(iv.preco_unitario) AS maior_preco
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
INNER JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
GROUP BY v.id_venda, c.nome
ORDER BY total_venda DESC;

-- 10. CONSULTA MAIS ÚTIL
-- Resumo das vendas por cliente, com quantidade e total gasto.
SELECT
    c.nome AS cliente,
    COUNT(DISTINCT v.id_venda) AS quantidade_vendas,
    ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS total_gasto
FROM cliente AS c
INNER JOIN venda AS v
    ON v.id_cliente = c.id_cliente
INNER JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;

-- 11. VALIDAÇÃO PRÁTICA
-- Esta consulta relaciona venda, cliente e funcionário.
SELECT
    v.id_venda,
    c.nome AS cliente,
    f.nome AS funcionario,
    v.status
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
INNER JOIN funcionario AS f
    ON f.id_funcionario = v.id_funcionario;

