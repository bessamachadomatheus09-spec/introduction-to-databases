
-- MODULE 2 - SPRINT 5/5
-- TRIGGERS, TRANSACOES E INTEGRACAO FINAL
-- Aluno: Matheus Bessa Machado
-- Banco: db_mercado
-- SGBD: MySQL

USE db_mercado;

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

SELECT id_produto, nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);


SELECT * FROM vw_vendas_detalhadas;
SELECT * FROM vw_vendas_resumo;
SELECT * FROM vw_vendas_abertas;
SELECT * FROM vw_produtos_vendidos;

CALL sp_listar_produtos_categoria('Bebidas');
CALL sp_listar_produtos_categoria('Limpeza');

CALL sp_listar_vendas_cliente(1);
CALL sp_listar_vendas_cliente(2);

CALL sp_contar_vendas_cliente(1, @total_vendas);
SELECT @total_vendas AS total_vendas_cliente_1;

CALL sp_contar_vendas_cliente(2, @total_vendas);
SELECT @total_vendas AS total_vendas_cliente_2;

SELECT fn_total_venda(1) AS total_venda_1;
SELECT fn_total_venda(2) AS total_venda_2;

DROP TRIGGER IF EXISTS trg_validar_preco_produto;

DELIMITER //

CREATE TRIGGER trg_validar_preco_produto
BEFORE UPDATE ON produto
FOR EACH ROW
BEGIN
    IF NEW.preco <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O preco do produto deve ser maior que zero.';
    END IF;
END //

DELIMITER ;


SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

START TRANSACTION;

UPDATE produto
SET preco = preco + 1.00
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

COMMIT;

START TRANSACTION;

UPDATE produto
SET preco = preco - 1.00
WHERE id_produto = 1;

COMMIT;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

START TRANSACTION;

UPDATE produto
SET preco = preco + 100.00
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

ROLLBACK;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

SHOW FULL TABLES WHERE Table_type = 'VIEW';

SELECT COUNT(*) AS total_clientes
FROM cliente;

SELECT COUNT(*) AS total_produtos
FROM produto;

SELECT COUNT(*) AS total_vendas
FROM venda;
