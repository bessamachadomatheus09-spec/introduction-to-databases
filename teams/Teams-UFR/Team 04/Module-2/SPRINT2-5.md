  # SPRINT 2/5: Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Aluno:** Matheus Bessa Machado  
**Banco:** `db_mercado`  
**SGBD:** MySQL

## 1. Identificação

Foi utilizado o banco `db_mercado`, desenvolvido no Módulo 1. O projeto representa um mercado e possui as tabelas `cliente`, `funcionario`, `produto`, `venda` e `item_venda`.

## 2. O que é uma subconsulta?

Uma subconsulta é um comando `SELECT` dentro de outra consulta. Ela permite utilizar o resultado de uma consulta interna para filtrar ou comparar os dados da consulta externa.

## 3. Perguntas que exigem subconsulta

1. Quais produtos possuem preço acima da média?
2. Quais clientes já realizaram vendas?
3. Quais clientes ainda não realizaram vendas?
4. Quais produtos aparecem em algum item de venda?
5. Qual produto possui o maior preço?

## 4. Subconsulta com comparação

**Pergunta:** Quais produtos custam mais que a média dos preços?

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

**Consulta interna:** Calcula a média dos preços cadastrados usando `AVG()`.

**Consulta externa:** Mostra os produtos cujo preço é maior que a média calculada.

## 5. Subconsulta com IN

**Pergunta:** Quais clientes já realizaram vendas?

```sql
SELECT id_cliente, nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM venda
);
```

**Explicação:** A subconsulta retorna os identificadores dos clientes presentes na tabela de vendas. O `IN` seleciona os clientes que possuem esses identificadores.

## 6. Subconsulta com NOT IN

**Pergunta:** Quais clientes ainda não realizaram vendas?

```sql
SELECT id_cliente, nome
FROM cliente
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM venda
);
```

**Registros procurados:** Clientes cujos identificadores não aparecem na tabela `venda`.

## 7. EXISTS

**Pergunta:** Quais produtos aparecem em algum item de venda?

```sql
SELECT p.id_produto, p.nome, p.preco
FROM produto AS p
WHERE EXISTS (
    SELECT 1
    FROM item_venda AS iv
    WHERE iv.id_produto = p.id_produto
);
```

**Explicação:** O `EXISTS` verifica se existe pelo menos um item de venda relacionado ao produto. Se existir, o produto será exibido.

## 8. NOT EXISTS

**Pergunta:** Quais produtos nunca foram vendidos?

```sql
SELECT p.id_produto, p.nome
FROM produto AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM item_venda AS iv
    WHERE iv.id_produto = p.id_produto
);
```

**Diferença:** O `EXISTS` seleciona registros que possuem correspondência. O `NOT EXISTS` seleciona aqueles que não possuem correspondência.

## 9. Subconsulta com MAX

**Pergunta:** Qual produto possui o maior preço?

```sql
SELECT id_produto, nome, preco
FROM produto
WHERE preco = (
    SELECT MAX(preco)
    FROM produto
);
```

**Explicação:** A subconsulta utiliza `MAX()` para encontrar o maior preço. A consulta externa mostra o produto que possui esse valor.

## 10. Subconsulta correlacionada

**Pergunta:** Quais produtos possuem preço acima da média de sua categoria?

```sql
SELECT p.nome, p.categoria, p.preco
FROM produto AS p
WHERE p.preco > (
    SELECT AVG(p2.preco)
    FROM produto AS p2
    WHERE p2.categoria = p.categoria
);
```

**Coluna utilizada:** A coluna `categoria` da consulta externa é comparada com `p2.categoria` na consulta interna. Assim, a média é calculada para a categoria do produto analisado.

## 11. Resolver a mesma pergunta de duas formas

### Pergunta 1: Quais clientes já realizaram vendas?

**JOIN**

```sql
SELECT DISTINCT c.id_cliente, c.nome
FROM cliente AS c
INNER JOIN venda AS v
    ON v.id_cliente = c.id_cliente
ORDER BY c.nome;
```

**SUBQUERY**

```sql
SELECT id_cliente, nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM venda
)
ORDER BY nome;
```

**Qual abordagem ficou mais compreensível?**

A subconsulta ficou mais compreensível para essa pergunta, pois permite identificar diretamente os clientes que possuem vendas.

### Pergunta 2: Quais produtos possuem preço acima da média geral?

**JOIN**

```sql
SELECT p.nome, p.preco
FROM produto AS p
INNER JOIN (
    SELECT AVG(preco) AS media_preco
    FROM produto
) AS m
    ON p.preco > m.media_preco
ORDER BY p.preco DESC;
```

**SUBQUERY**

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
)
ORDER BY preco DESC;
```

**Comparação**

As duas consultas buscam o mesmo resultado. A subconsulta é mais simples de entender nesse caso, enquanto o `JOIN` permite relacionar os produtos com o resultado da média como uma tabela derivada.

## 12. Validação prática

**Consulta escolhida:** Produtos com preço acima da média.

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

1. **Qual consulta é executada primeiro?** A consulta interna, que calcula a média dos preços.
2. **Qual valor ela retorna?** Um único valor numérico correspondente à média dos preços cadastrados.
3. **Como o resultado é utilizado?** A consulta externa compara o preço de cada produto com essa média e exibe os que possuem preço superior.

## 13. Teste operacional no Workbench

**Consulta original:**

```sql
SELECT nome, preco
FROM produto
WHERE preco > 10.00
ORDER BY preco DESC;
```

**Alteração realizada:** Trocar o valor do filtro de `10.00` para `15.00`.

**Mudança observada:** Com o filtro maior, somente os produtos com preço acima de R$ 15,00 serão exibidos. A quantidade de resultados pode diminuir.

## 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Coluna ambígua | Colunas com nomes iguais em tabelas diferentes | Utilizar apelidos como `p.preco` |
| Consulta sem resultados | Nenhum registro atende ao filtro | Conferir os dados e a condição |
| Erro em subconsulta | Sintaxe incorreta ou retorno incompatível com a comparação | Revisar o `SELECT` interno e o operador utilizado |

## 15. Checklist

- [x] Subconsulta com comparação
- [x] Subconsulta com `IN`
- [x] Subconsulta com `NOT IN`
- [x] Consulta com `EXISTS`
- [x] Consulta com `NOT EXISTS`
- [x] Subconsulta com `MAX`
- [x] Subconsulta correlacionada
- [x] Duas perguntas resolvidas com `JOIN` e subconsulta
- [x] Explicação do raciocínio
- [ ] Executar e conferir as consultas no MySQL Workbench
- [ ] Preencher os resultados reais dos testes
- [ ] Salvar os arquivos na pasta `Module-2`

## 16. Git/GitHub

**Arquivos:**

```text
Module-2/SPRINT2-5.md
Module-2/SPRINT2-5.sql
```

**Commit sugerido:**

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```

A atividade deve continuar na branch `team-XX`, sem abrir o Pull Request final nesta etapa.