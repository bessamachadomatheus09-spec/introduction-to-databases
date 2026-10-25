# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# Objetivo da Sprint 1/5

Nesta primeira Sprint do **Module-2**, cada aluno deverá continuar utilizando o mesmo banco de dados desenvolvido no `Module-1`.

O foco agora será a consulta de dados relacionados entre duas ou mais tabelas por meio de:

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
ON
AS
WHERE
ORDER BY
GROUP BY
COUNT
SUM
AVG
MIN
MAX
```

Ao final da Sprint, o aluno deverá ser capaz de identificar as tabelas necessárias, reconhecer PK e FK envolvidas, construir consultas com `JOIN`, interpretar os resultados e explicar presencialmente como cada consulta funciona.

> **Importante:** não crie um novo banco. Utilize o mesmo projeto desenvolvido no `Module-1`.

---

# 1. Estrutura do repositório

Os arquivos desta Sprint deverão ficar em:

```text
teams/Teams-UNEMAT/team-XX/Module-2/
```

Ao final:

```text
Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

Não altere nem apague os arquivos do `Module-1`.

---

# 2. Identificação

**Nome completo:**

> Matheus Bessa

**Branch:**

```text
team-04```

**Nome do banco:**

```text

```Mercado

**Tema do projeto:**

> Escreva aqui.

--- Banco de dados de um mercado 

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

Nº  |	Tabela | PK | Principais FKs
1 |cliente |	id_cliente | Não possui
2 |	funcionario |	id_funcionario | Não possui
3 |	produto  |	id_produto | Não possui
4 |	venda |	id_venda | id_cliente, id_funcionario
5 |	item_venda |	id_item_venda | id_venda, id_produto

---

# 4. Relacionamentos existentes

Tabela A | Cardinalidade | Tabela B | FK utilizada
cliente | 1:N |	venda |	venda.id_cliente
funcionario | 1:N |	venda | venda.id_funcionario
venda |	1:N | item_venda | item_venda.id_venda
produto | 1:N |	item_venda | item_venda.id_produto

---

# 5. INNER JOIN

O `INNER JOIN` retorna registros que possuem correspondência nas tabelas relacionadas.

Exemplo genérico:

```sql
SELECT
    a.campo,
    b.campo
FROM tabela_a AS a
INNER JOIN tabela_b AS b
    ON a.id = b.id_a;
```

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Escreva aqui.
>Quais vendas foram realizadas, quais clientes compraram e quais funcionários atenderam?

**Tabelas utilizadas:**

```text

```venda, cliente e funcionario.

**PK/FK utilizadas:**

```text

```venda.id_venda, venda.id_cliente e venda.id_funcionario.

**SQL:**

```sql
-- Cole aqui.
```SELECT
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

**Explique o resultado:**

> Escreva aqui.
A consulta mostra as vendas junto com o nome dos clientes e dos funcionários responsáveis. O INNER JOIN retorna apenas os registros que possuem correspondência entre as tabelas relacionadas.

## Consulta INNER JOIN 2

**Pergunta:** 

> Escreva aqui.
Quais produtos aparecem em cada venda e qual é a quantidade comprada?
```sql
-- Cole aqui.
```SELECT
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

**Explique:**

> Escreva aqui.

---A consulta relaciona os itens às vendas e aos produtos. Assim, é possível ver o nome do produto, a quantidade comprada, o preço unitário e o subtotal de cada item.

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.
Quantas vendas cada cliente possui, incluindo aqueles que ainda não realizaram nenhuma compra?
```sql
-- Cole aqui.
```SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(v.id_venda) AS quantidade_vendas
FROM cliente AS c
LEFT JOIN venda AS v
    ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_vendas DESC, c.nome;

**O que o LEFT JOIN permite visualizar neste caso?**

> Escreva aqui.

---Ele permite mostrar todos os clientes, mesmo aqueles que não possuem vendas. Para esses clientes, a quantidade de vendas será zero.

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```SELECT
    p.id_produto,
    p.nome AS produto,
    iv.id_item_venda,
    iv.id_venda,
    iv.quantidade
FROM item_venda AS iv
RIGHT JOIN produto AS p
    ON p.id_produto = iv.id_produto
ORDER BY p.nome;

**Explique o resultado:**

> Escreva aqui.

---O RIGHT JOIN mantém todos os produtos cadastrados, mesmo quando não possuem itens de venda relacionados. Nesse caso, os campos da tabela item_venda aparecem como NULL.

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Escreva aqui.
``Quais clientes compraram quais produtos em cada venda?
```sql
-- Cole aqui.
```SELECT
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

## Consulta 2

**Pergunta:**

> Escreva aqui.
``Qual funcionário atendeu cada venda e qual foi o valor total dos itens vendidos?
```sql
-- Cole aqui.
```SELECT
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

---

# 9. JOIN + WHERE

**Pergunta:**

> Escreva aqui.
```Quais vendas foram finalizadas e quais clientes realizaram essas compras?
```sql
-- Cole aqui.
```SELECT
    v.id_venda,
    c.nome AS cliente,
    v.data_venda,
    v.status
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
WHERE v.status = 'finalizada'
ORDER BY v.data_venda;

**Explique o filtro:**

> Escreva aqui.

---O WHERE filtra os resultados para mostrar somente as vendas com status finalizada. Dessa forma, as vendas abertas ou canceladas não aparecem.

# 10. JOIN + ORDER BY

**Pergunta:**
```Quais produtos tiveram os maiores subtotais nos itens vendidos?
> Escreva aqui.

```sql
-- Cole aqui.
```SELECT
    p.nome AS produto,
    iv.id_venda,
    iv.quantidade,
    iv.preco_unitario,
    ROUND(iv.quantidade * iv.preco_unitario, 2) AS subtotal
FROM item_venda AS iv
INNER JOIN produto AS p
    ON p.id_produto = iv.id_produto
ORDER BY subtotal DESC;

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**
Qual foi o valor total de cada venda e quais foram os preços mínimo, máximo e médio dos itens?
> Escreva aqui.

```sql
-- Cole aqui.
```SELECT
    v.id_venda,
    c.nome AS cliente,
    COUNT(iv.id_item_venda) AS quantidade_de_itens,
    ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS total_venda,
    AVG(iv.preco_unitario) AS preco_medio,
    MIN(iv.preco_unitario) AS menor_preco,
    MAX(iv.preco_unitario) AS maior_preco
FROM venda AS v
INNER JOIN cliente AS c
    ON c.id_cliente = v.id_cliente
INNER JOIN item_venda AS iv
    ON iv.id_venda = v.id_venda
GROUP BY v.id_venda, c.nome
ORDER BY total_venda DESC;

**Explique o agrupamento:**

> Escreva aqui.

---

# 12. Quantidade mínima exigida

O `SPRINT1-5.sql` deverá conter, no mínimo:

```text
2 INNER JOIN
1 LEFT JOIN
1 RIGHT JOIN
2 consultas envolvendo 3 ou mais tabelas
1 JOIN + WHERE
1 JOIN + ORDER BY
1 JOIN + GROUP BY + agregação
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Consulta mais útil

**Pergunta:**
```Quais clientes realizaram compras e quanto gastaram no total?
> Escreva aqui.

```sql
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
ORDER BY total_gasto DESC;```

**Por que ela é útil?**

> Escreva aqui.

---Essa consulta ajuda o mercado a identificar os clientes que mais gastaram e a quantidade de vendas de cada um. Essas informações podem ser usadas para analisar as vendas e planejar promoções.

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
-- Cole aqui.
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> Escreva aqui.

---1.Participam as tabelas venda, cliente e funcionario.

2.São utilizadas as PKs id_cliente e id_funcionario para identificar os clientes e funcionários relacionados. A tabela venda também possui a PK id_venda.

3.As FKs utilizadas são venda.id_cliente e venda.id_funcionario.

4.A cláusula ON define a condição de relacionamento entre as tabelas, comparando as FKs da tabela venda com as PKs das tabelas correspondentes.

5.A consulta poderia relacionar registros incorretos, gerar linhas duplicadas ou apresentar resultados diferentes do esperado.

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
-- Cole aqui.
```

Resultado esperado:

Uma linha para cada venda, mostrando seu identificador, o nome do cliente, o funcionário responsável e o status.

Resultado obtido:

Preencher após executar a consulta no MySQL Workbench e conferir o resultado apresentado.

# 16. Problemas encontrados

Problema	Causa	Solução
Coluna ambígua | Duas tabelas podem possuir colunas com o mesmo nome | Informar o apelido da tabela antes da coluna
Linhas duplicadas |	Uma venda pode possuir vários itens	| Utilizar GROUP BY e funções de agregação quando necessário
Registros não aparecem | O INNER JOIN exige correspondência entre as tabelas  | Utilizar LEFT JOIN ou RIGHT JOIN quando for necessário manter todos os registros de um dos lados
---

# 17. Uso de LLMs

LLMs podem ser utilizadas como apoio, mas todo código deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

O aluno deverá ser capaz de explicar presencialmente qualquer consulta entregue.

---

# 18. Estrutura recomendada do SPRINT1-5.sql

```sql
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- INNER JOIN 1

-- INNER JOIN 2

-- LEFT JOIN

-- RIGHT JOIN

-- JOIN COM 3+ TABELAS 1

-- JOIN COM 3+ TABELAS 2

-- JOIN + WHERE

-- JOIN + ORDER BY

-- JOIN + GROUP BY + AGREGAÇÃO
```

---

# 19. Checklist

- [ ] utilizei o mesmo banco do Module-1;
- [ ] identifiquei PKs e FKs;
- [ ] produzi 2 `INNER JOIN`;
- [ ] produzi 1 `LEFT JOIN`;
- [ ] produzi 1 `RIGHT JOIN`;
- [ ] produzi consultas com 3 ou mais tabelas;
- [ ] utilizei `WHERE`;
- [ ] utilizei `ORDER BY`;
- [ ] utilizei agregação e `GROUP BY`;
- [ ] as consultas respondem perguntas reais;
- [ ] testei tudo no MySQL Workbench;
- [ ] consigo explicar as consultas;
- [ ] salvei `SPRINT1-5.md`;
- [ ] salvei `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Continue utilizando:

```text
team-XX
```

Arquivos do commit:

```text
Module-2/SPRINT1-5.md
Module-2/SPRINT1-5.sql
```

Mensagem sugerida:

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
```

**Não abra o Pull Request final nesta Sprint.**

---

# Próxima etapa

Na Sprint 2/5 serão trabalhadas subconsultas:

```sql
IN
NOT IN
EXISTS
NOT EXISTS
subconsultas correlacionadas
```
