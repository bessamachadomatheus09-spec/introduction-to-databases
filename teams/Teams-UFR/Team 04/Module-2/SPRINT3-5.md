# SPRINT 3/5: Views e Abstração de Consultas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Aluno:** Matheus Bessa Machado  
**Banco:** `db_mercado`  
**SGBD:** MySQL

## 1. Identificação

Foi utilizado o banco `db_mercado`, desenvolvido no Módulo 1. O projeto representa um mercado e possui cinco tabelas principais: `cliente`, `funcionario`, `produto`, `venda` e `item_venda`.

## 2. Consultas do projeto que merecem reutilização

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Vendas detalhadas | Mostra clientes e funcionários de cada venda | Sim |
| Resumo das vendas | Calcula a quantidade de itens e o total de cada venda | Sim |
| Vendas abertas | Ajuda a identificar vendas que ainda não foram finalizadas | Sim |
| Produtos vendidos | Mostra os produtos presentes nos itens de venda | Sim |

## 3. Criando uma VIEW

Uma `VIEW` é uma consulta SQL armazenada que pode ser utilizada como uma tabela virtual. Ela facilita a reutilização de consultas e organiza o acesso às informações.

## 4. VIEW 1: Relacionamento entre tabelas

**Nome da VIEW:** `vw_vendas_detalhadas`

**Pergunta:** Quais vendas foram realizadas, por quais clientes e funcionários?

**SQL:**

```sql
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
```

**Tabelas utilizadas:** `venda`, `cliente` e `funcionario`.

**Como consultar essa VIEW?**

```sql
SELECT *
FROM vw_vendas_detalhadas;
```

A View reúne informações de três tabelas em uma consulta reutilizável.

## 5. VIEW 2: Agregação ou resumo

**Pergunta:** Qual é o total de cada venda e quantos itens foram registrados nela?

```sql
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
```

**Explicação:** A View relaciona vendas, clientes e itens. O `COUNT` conta os itens registrados, enquanto o `SUM` calcula o valor total. O `GROUP BY` agrupa os resultados por venda e cliente. O `COALESCE` retorna zero quando a venda não possui itens.

## 6. VIEW 3: Consulta operacional

**Nome da VIEW:** `vw_vendas_abertas`

**Pergunta:** Quais vendas ainda estão abertas?

```sql
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
```

**Por que essa VIEW é útil?**

Ela permite consultar rapidamente as vendas que ainda não foram finalizadas, facilitando o acompanhamento das operações do mercado.

## 7. Consultando uma VIEW

**SQL executado:**

```sql
SELECT *
FROM vw_vendas_resumo;

SELECT *
FROM vw_vendas_resumo
WHERE total_venda > 20.00;
```

**Resultado observado:** A primeira consulta apresenta o resumo das vendas. A segunda mostra apenas as vendas cujo total é superior a R$ 20,00. A quantidade de registros depende dos dados existentes no banco.

## 8. CREATE OR REPLACE VIEW

**VIEW original:** `vw_vendas_resumo`, que apresenta o identificador da venda, o cliente, a quantidade de itens e o total.

**Nova versão:**

```sql
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
```

**O que mudou?**

Foi adicionada a coluna `status`, que informa se a venda está aberta, finalizada ou cancelada. O `CREATE OR REPLACE VIEW` atualiza a definição da View existente.

## 9. DROP VIEW: Exercício controlado

**Código utilizado:**

```sql
CREATE VIEW vw_teste AS
SELECT id_produto, nome, preco
FROM produto
WHERE preco > 10.00;

SELECT *
FROM vw_teste;

DROP VIEW vw_teste;
```

**Diferença entre DROP VIEW e DROP TABLE:**

O `DROP VIEW` remove uma consulta virtual armazenada. O `DROP TABLE` remove uma tabela e sua estrutura, incluindo os dados armazenados nela.

## 10. Validando as Views

**Comando utilizado:**

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views esperadas após a execução completa:**

1. `vw_vendas_detalhadas`
2. `vw_vendas_resumo`
3. `vw_vendas_abertas`
4. `vw_produtos_vendidos`

A lista deve ser conferida após executar o script no MySQL Workbench.

## 11. Teste de atualização dos dados-base

**VIEW testada:** `vw_produtos_vendidos`.

**Alteração realizada:**

```sql
UPDATE produto
SET preco = preco + 1.00
WHERE id_produto = 1;
```

Depois, consulte novamente:

```sql
SELECT *
FROM vw_produtos_vendidos;
```

Para restaurar o preço original:

```sql
UPDATE produto
SET preco = preco - 1.00
WHERE id_produto = 1;
```

**Resultado observado:** Como a View consulta os dados da tabela `produto`, o preço atualizado aparece na nova consulta. Após restaurar o preço, a consulta volta a apresentar o valor anterior. Esse teste pressupõe que o produto de identificador 1 existe e que o comando foi executado com sucesso.

## 12. Validação prática obrigatória

**VIEW escolhida:** `vw_vendas_detalhadas`.

```sql
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
```

1. **Tabelas utilizadas:** `venda`, `cliente` e `funcionario`.
2. **Relacionamento utilizado:** As chaves estrangeiras `venda.id_cliente` e `venda.id_funcionario` se relacionam com as chaves primárias das tabelas correspondentes.
3. **Campos apresentados:** Identificador da venda, cliente, funcionário, data e status.
4. **Problema resolvido:** Reúne em uma consulta informações que estão separadas em três tabelas.
5. **Alteração dos dados:** Quando os dados das tabelas originais são alterados, a View passa a apresentar os dados atualizados nas consultas seguintes.

## 13. Quantidade mínima exigida

- [x] View com relacionamento entre tabelas.
- [x] View com agregação e `GROUP BY`.
- [x] View operacional.
- [x] `CREATE OR REPLACE VIEW`.
- [x] Exercício com `DROP VIEW`.
- [x] Consultas sobre as Views.
- [ ] Executar e conferir os resultados no MySQL Workbench.

## 14. Estrutura do projeto

```text
Module-2/
├── SPRINT3-5.md
└── SPRINT3-5.sql
```

## 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| View já existe | Nome já utilizado no banco | Utilizar `CREATE OR REPLACE VIEW` ou remover a View antes de criá-la |
| Coluna ambígua | Mais de uma tabela possui uma coluna com o mesmo nome | Utilizar os apelidos das tabelas |
| Resultado desatualizado na tela | A consulta não foi executada novamente | Consultar a View novamente |

## 16. Uso de LLMs

O apoio de uma ferramenta de inteligência artificial foi utilizado para auxiliar na elaboração das consultas e explicações. O código deverá ser compreendido, adaptado quando necessário, executado e validado no MySQL Workbench.

**Fluxo utilizado:**

COMPREENDER → ADAPTAR → EXECUTAR → TESTAR → VALIDAR

## 17. Checklist

- [x] Utilizei o banco do projeto.
- [x] Criei pelo menos três Views úteis.
- [x] Uma View utiliza `JOIN`.
- [x] Uma View utiliza agregação.
- [x] Consultei as Views no código.
- [x] Utilizei `CREATE OR REPLACE VIEW`.
- [x] Pratiquei `DROP VIEW`.
- [x] Incluí o comando de validação.
- [x] Incluí o teste de atualização da tabela-base.
- [ ] Executei e conferi os resultados no MySQL Workbench.
- [ ] Salvei os arquivos na pasta `Module-2`.

## 18. Git/GitHub

**Arquivos:**

```text
Module-2/SPRINT3-5.md
Module-2/SPRINT3-5.sql
```

**Branch:** `team-XX`

**Commit sugerido:**

```text
Conclui Module 2 Sprint 3 de 5 - views
```

Não abrir o Pull Request final nesta etapa.