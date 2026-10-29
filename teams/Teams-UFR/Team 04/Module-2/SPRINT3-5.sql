
-- ============================================================
-- SPRINT3-5.sql
-- MODULE 2 - SPRINT 3/5
-- VIEWS E ABSTRACAO DE CONSULTAS
-- Aluno: Matheus Bessa Machado
-- Banco: db_mercado
-- SGBD: MySQL
-- ============================================================

USE db_mercado;

-- Remove as Views anteriores para permitir executar o script novamente.
DROP VIEW IF EXISTS vw_teste;
DROP VIEW IF EXISTS vw_vendas_resumo;
DROP VIEW IF EXISTS vw_produtos_vendidos;
DROP VIEW IF EXISTS vw_vendas_detalhadas;

CREATE VIEW vw_vendas_detalhadas AS
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
    ON f.id_funcionario = v.id_funcionario;

CREATE VIEW vw_vendas_resumo AS
SELECT
    v.id_venda,
    c.nome AS cliente,
    COUNT(iv.id_item_venda) AS quantidade_itens,
    COALESCE(
        ROUND(SUM(iv.quantidade * iv.preco_unitario), 2),
        0
    ) AS total_venda
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
LEFT JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
GROUP BY v.id_venda, c.nome;


CREATE VIEW vw_vendas_abertas AS
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
WHERE v.status = 'aberta';


SELECT *
FROM vw_vendas_detalhadas;

SELECT *
FROM vw_vendas_resumo;

SELECT *
FROM vw_vendas_abertas;


SELECT *
FROM vw_vendas_resumo
WHERE total_venda > 20.00;


CREATE OR REPLACE VIEW vw_vendas_resumo AS
SELECT
    v.id_venda,
    c.nome AS cliente,
    v.status,
    COUNT(iv.id_item_venda) AS quantidade_itens,
    COALESCE(
        ROUND(SUM(iv.quantidade * iv.preco_unitario), 2),
        0
    ) AS total_venda
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
LEFT JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
GROUP BY v.id_venda, c.nome, v.status;


SELECT *
FROM vw_vendas_resumo;


CREATE VIEW vw_teste AS
SELECT id_produto, nome, preco
FROM produto
WHERE preco > 10.00;


SELECT *
FROM vw_teste;


DROP VIEW vw_teste;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';
SELECT *
FROM vw_produtos_vendidos;

UPDATE produto
SET preco = preco + 1.00
WHERE id_produto = 1;


SELECT *
FROM vw_produtos_vendidos;

UPDATE produto
SET preco = preco - 1.00
WHERE id_produto = 1;


CREATE VIEW vw_produtos_vendidos AS
SELECT DISTINCT
    p.id_produto,
    p.nome AS produto,
    p.preco,
    p.categoria
FROM produto AS p
INNER JOIN item_venda AS iv
    ON iv.id_produto = p.id_produto;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';
