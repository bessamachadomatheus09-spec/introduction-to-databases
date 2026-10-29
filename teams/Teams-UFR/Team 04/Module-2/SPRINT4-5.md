# SPRINT 4/5: Stored Procedures e Functions

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Aluno:** Matheus Bessa Machado  
**Banco utilizado:** `db_mercado`  
**SGBD:** MySQL

---

## 1. Identificação

O projeto utiliza o banco de dados `db_mercado`, que possui informações de clientes, funcionários, produtos, vendas e itens vendidos.

## 2. Planejamento das rotinas

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| `sp_listar_produtos_categoria` | Procedure | Categoria | Lista de produtos | Buscar produtos por categoria |
| `sp_listar_vendas_cliente` | Procedure | ID do cliente | Lista de vendas | Consultar as vendas de um cliente |
| `sp_contar_vendas_cliente` | Procedure | ID do cliente | Quantidade de vendas (`OUT`) | Contar as vendas do cliente |
| `fn_total_venda` | Function | ID da venda | Valor total | Calcular o total de uma venda |

## 3. DELIMITER

O `DELIMITER` muda temporariamente o símbolo usado para identificar o fim de um comando SQL. Ele permite criar Procedures e Functions com vários comandos dentro de um mesmo bloco, sem que o MySQL encerre a definição no primeiro ponto e vírgula.

## 4. Procedure 1: parâmetro IN

**Objetivo:** listar os produtos de uma categoria informada.

**Parâmetro de entrada:** `p_categoria`, que recebe o nome da categoria.

**Execução:**

```sql
CALL sp_listar_produtos_categoria('Bebidas');
CALL sp_listar_produtos_categoria('Limpeza');
```

**Resultado esperado:** cada chamada apresenta os produtos cadastrados na categoria informada. Se a categoria estiver vazia, a rotina apresenta uma mensagem solicitando uma categoria válida.

## 5. Procedure 2: operação do domínio

**Objetivo:** consultar as vendas realizadas por determinado cliente.

**Parâmetro de entrada:** `p_id_cliente`, que identifica o cliente.

**Execução:**

```sql
CALL sp_listar_vendas_cliente(1);
CALL sp_listar_vendas_cliente(2);
```

**Resultado esperado:** são exibidas as vendas do cliente informado, incluindo o identificador da venda, o nome do cliente, o funcionário responsável, a data e o status.

## 6. Procedure com OUT

**Objetivo:** contar quantas vendas pertencem a um cliente.

O parâmetro `p_id_cliente` recebe o identificador do cliente, enquanto `p_total` devolve a quantidade de vendas encontradas.

**Execução:**

```sql
CALL sp_contar_vendas_cliente(1, @total_vendas);
SELECT @total_vendas AS total_vendas_cliente_1;

CALL sp_contar_vendas_cliente(2, @total_vendas);
SELECT @total_vendas AS total_vendas_cliente_2;
```

**Resultado esperado:** a variável `@total_vendas` apresenta a quantidade de vendas de cada cliente. Se não houver vendas, o resultado será zero.

## 7. Function obrigatória

**Nome:** `fn_total_venda`

**Objetivo:** calcular o valor total de uma venda somando a quantidade de cada produto multiplicada pelo seu preço unitário.

**Parâmetro recebido:** `p_id_venda`, identificador da venda.

**Valor retornado:** número decimal com o total calculado.

**Exemplo de uso:**

```sql
SELECT fn_total_venda(1) AS total_venda_1;
SELECT fn_total_venda(2) AS total_venda_2;
```

**Resultado esperado:** cada consulta retorna o valor total dos itens da venda informada. Se não houver itens associados à venda, a função retorna zero.

## 8. IF / ELSE

A regra de negócio está na Procedure `sp_listar_produtos_categoria`.

- **IF:** verifica se a categoria recebida é nula ou vazia.
- **THEN:** apresenta uma mensagem solicitando uma categoria válida.
- **ELSE:** consulta e retorna os produtos da categoria informada.

Essa validação evita realizar uma busca sem que o usuário informe uma categoria.

## 9. Procedure x Function

### Procedure

Uma Procedure executa uma sequência de comandos SQL e pode receber parâmetros de entrada e devolver resultados por parâmetros de saída. É útil para executar operações e consultas reutilizáveis.

### Function

Uma Function calcula e retorna um valor que pode ser utilizado em uma consulta SQL, por exemplo, em um `SELECT`.

### Quando utilizar cada uma no projeto?

Utilizaria Procedures para listar produtos, consultar vendas e contar registros. Utilizaria uma Function para calcular o valor total de uma venda e reutilizar esse cálculo em consultas.

## 10. Testes obrigatórios

Os testes abaixo utilizam parâmetros diferentes. Os resultados reais dependem dos dados cadastrados no banco.

### Procedure 1

```sql
CALL sp_listar_produtos_categoria('Bebidas');
CALL sp_listar_produtos_categoria('Limpeza');
```

**Resultados:** verificar se cada chamada retorna os produtos da categoria correspondente.

### Procedure 2

```sql
CALL sp_listar_vendas_cliente(1);
CALL sp_listar_vendas_cliente(2);
```

**Resultados:** verificar se cada chamada retorna as vendas do cliente informado.

### Procedure com OUT

```sql
CALL sp_contar_vendas_cliente(1, @total_vendas);
SELECT @total_vendas;

CALL sp_contar_vendas_cliente(2, @total_vendas);
SELECT @total_vendas;
```

**Resultados:** verificar a quantidade de vendas de cada cliente.

### Function

```sql
SELECT fn_total_venda(1);
SELECT fn_total_venda(2);
```

**Resultados:** verificar o total calculado para cada venda.

## 11. Validação prática presencial

**Rotina escolhida:** `sp_listar_produtos_categoria`

```sql
CALL sp_listar_produtos_categoria('Bebidas');
CALL sp_listar_produtos_categoria('Limpeza');
```

A rotina recebe uma categoria e consulta a tabela `produto`. Ao alterar o parâmetro, os produtos retornados mudam conforme a categoria informada. A condição `IF/ELSE` também verifica se o parâmetro está vazio.

## 12. Quantidade mínima exigida

O projeto contém quatro rotinas planejadas: três Procedures e uma Function. Também utiliza parâmetro `IN`, parâmetro `OUT`, declaração de variável com `DECLARE`, retorno com `RETURN` e condição `IF/ELSE`.

## 13. Estrutura do arquivo SQL

O arquivo `SPRINT4-5.sql` contém a seleção do banco, a remoção das rotinas anteriores, a criação das Procedures e da Function, a configuração do `DELIMITER` e os comandos para testar cada rotina.

## 14. Problemas encontrados

| Problema possível | Causa | Solução |
|---|---|---|
| Erro na criação de uma rotina | Uso incorreto do `DELIMITER` | Conferir o início e o fim de cada bloco |
| Coluna não encontrada | Nome diferente no banco | Conferir a estrutura real das tabelas |
| Categoria sem resultados | Categoria não cadastrada | Utilizar uma categoria existente |
| Erro ao criar Function | Permissões ou configuração do MySQL | Verificar as permissões e a configuração do servidor |

## 15. Uso de LLMs

A ferramenta de inteligência artificial foi utilizada como apoio para estruturar e compreender as rotinas SQL. É necessário adaptar os comandos à estrutura real do banco, executar os testes e validar os resultados.

Fluxo seguido:

**Compreender → Adaptar → Executar → Testar → Validar**

## 16. Checklist

- [x] Planejei pelo menos duas Procedures.
- [x] Planejei uma Function.
- [x] Utilizei parâmetro `IN`.
- [x] Incluí uma rotina com `OUT`.
- [x] Utilizei `IF/ELSE`.
- [ ] Executei todas as rotinas no MySQL.
- [ ] Testei parâmetros diferentes e conferi os resultados.
- [ ] Confirmei que compreendo todas as rotinas.
- [ ] Salvei `SPRINT4-5.md`.
- [ ] Salvei `SPRINT4-5.sql`.

*Marque os itens de execução e validação somente depois de realizar os testes.*

## 17. Git/GitHub

Arquivos da entrega:

```text
Module-2/SPRINT4-5.md
Module-2/SPRINT4-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 4 de 5 - procedures e functions
```

Continuar na mesma branch `team-XX`, substituindo pelo nome da branch utilizada no projeto. Não abrir o Pull Request final ainda.

## 18. Próxima etapa

Na Sprint 5/5 serão trabalhados `TRIGGER`, `START TRANSACTION`, `COMMIT` e `ROLLBACK`, integrando os recursos desenvolvidos no Módulo 2.
