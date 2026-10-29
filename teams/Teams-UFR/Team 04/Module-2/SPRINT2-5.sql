
USE mercado;

SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
)
ORDER BY preco DESC;

SELECT id_cliente, nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM venda
)
ORDER BY nome;

SELECT id_cliente, nome
FROM cliente
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM venda
)
ORDER BY nome;

SELECT p.id_produto, p.nome, p.preco
FROM produto AS p
WHERE EXISTS (
    SELECT 1
    FROM item_venda AS iv
    WHERE iv.id_produto = p.id_produto
)
ORDER BY p.nome;

SELECT p.id_produto, p.nome
FROM produto AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM item_venda AS iv
    WHERE iv.id_produto = p.id_produto
)
ORDER BY p.nome;

SELECT id_produto, nome, preco
FROM produto
WHERE preco = (
    SELECT MAX(preco)
    FROM produto
);


SELECT p.nome, p.categoria, p.preco
FROM produto AS p
WHERE p.preco > (
    SELECT AVG(p2.preco)
    FROM produto AS p2
    WHERE p2.categoria = p.categoria
)
ORDER BY p.categoria, p.preco DESC;

SELECT DISTINCT
    c.id_cliente,
    c.nome
FROM cliente AS c
INNER JOIN venda AS v
    ON v.id_cliente = c.id_cliente
ORDER BY c.nome;

SELECT id_cliente, nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM venda
)
ORDER BY nome;

SELECT p.nome, p.preco
FROM produto AS p
INNER JOIN (
    SELECT AVG(preco) AS media_preco
    FROM produto
) AS m
    ON p.preco > m.media_preco
ORDER BY p.preco DESC;

SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
)
ORDER BY preco DESC;

SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
)
ORDER BY preco DESC;




SELECT nome, preco
FROM produto
WHERE preco > 10.00
ORDER BY preco DESC;
