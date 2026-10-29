
-- MODULE 2 - SPRINT 4/5
-- STORED PROCEDURES E FUNCTIONS
-- Aluno: Matheus Bessa Machado
-- Banco: db_mercado
-- SGBD: MySQL

USE db_mercado;


DROP PROCEDURE IF EXISTS sp_listar_produtos_categoria;
DROP PROCEDURE IF EXISTS sp_listar_vendas_cliente;
DROP PROCEDURE IF EXISTS sp_contar_vendas_cliente;
DROP FUNCTION IF EXISTS fn_total_venda;

DELIMITER //

CREATE PROCEDURE sp_listar_produtos_categoria(
    IN p_categoria VARCHAR(100)
)
BEGIN
    IF p_categoria IS NULL OR TRIM(p_categoria) = '' THEN
        SELECT 'Informe uma categoria valida.' AS mensagem;
    ELSE
        SELECT id_produto, nome, preco, categoria
        FROM produto
        WHERE categoria = p_categoria;
    END IF;
END //

CREATE PROCEDURE sp_listar_vendas_cliente(
    IN p_id_cliente INT
)
BEGIN
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
    WHERE v.id_cliente = p_id_cliente
    ORDER BY v.data_venda DESC;
END //

CREATE PROCEDURE sp_contar_vendas_cliente(
    IN p_id_cliente INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM venda
    WHERE id_cliente = p_id_cliente;
END //

CREATE FUNCTION fn_total_venda(
    p_id_venda INT
)
RETURNS DECIMAL(10,2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(quantidade * preco_unitario), 0)
    INTO v_total
    FROM item_venda
    WHERE id_venda = p_id_venda;

    RETURN v_total;
END //

DELIMITER ;

CALL sp_listar_produtos_categoria('Bebidas');
CALL sp_listar_produtos_categoria('Limpeza');

CALL sp_listar_produtos_categoria('');

CALL sp_listar_vendas_cliente(1);
CALL sp_listar_vendas_cliente(2);

CALL sp_contar_vendas_cliente(1, @total_vendas);
SELECT @total_vendas AS total_vendas_cliente_1;

CALL sp_contar_vendas_cliente(2, @total_vendas);
SELECT @total_vendas AS total_vendas_cliente_2;

SELECT fn_total_venda(1) AS total_venda_1;
SELECT fn_total_venda(2) AS total_venda_2;
