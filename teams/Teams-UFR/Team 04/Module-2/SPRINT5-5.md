# SPRINT 5/5: Triggers, Transações, Integração e Validação Final

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Aluno:** Matheus Bessa Machado  
**Banco utilizado:** `db_mercado`  
**SGBD:** MySQL

---

## 1. Identificação

O projeto utiliza o banco `db_mercado`, com tabelas de clientes, funcionários, produtos, vendas e itens vendidos.

## 2. Revisão do Module-2

| Sprint | Conteúdo | Concluído? |
|---|---|---|
| 1/5 | JOINs | [ ] |
| 2/5 | Subconsultas | [ ] |
| 3/5 | Views | [ ] |
| 4/5 | Procedures e Functions | [ ] |
| 5/5 | Triggers e Transações | [ ] |

*Marcar cada etapa após conferir os arquivos e executar os testes.*

## 3. Planejamento do Trigger

**Regra escolhida:** impedir que o preço de um produto seja alterado para zero ou um valor negativo.

**Evento:** `BEFORE UPDATE`

**Tabela envolvida:** `produto`

A regra ajuda a manter os preços cadastrados válidos.

## 4. Implementação do Trigger

```sql
DELIMITER //

CREATE TRIGGER trg_validar_preco_produto
BEFORE UPDATE ON produto
FOR EACH ROW
BEGIN
    IF NEW.preco <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'O preco do produto deve ser maior que zero.';
    END IF;
END //

DELIMITER ;
```

### Explicação linha por linha

- `DELIMITER //`: altera temporariamente o delimitador.
- `CREATE TRIGGER`: cria o Trigger.
- `BEFORE UPDATE ON produto`: executa a validação antes de atualizar um produto.
- `FOR EACH ROW`: aplica a regra a cada linha alterada.
- `IF NEW.preco <= 0`: verifica se o novo preço é inválido.
- `SIGNAL SQLSTATE '45000'`: gera um erro quando a regra é violada.
- `MESSAGE_TEXT`: apresenta a mensagem explicando o problema.
- `END`: encerra o bloco e o Trigger.

## 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;
```

**Operação executada:**

```sql
UPDATE produto
SET preco = 0
WHERE id_produto = 1;
```

**Estado depois do teste:**

```sql
SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;
```

**Resultado esperado:** o MySQL apresenta uma mensagem de erro e impede a atualização para preço zero. O preço anterior deve permanecer inalterado.

## 6. START TRANSACTION

O comando `START TRANSACTION` inicia uma transação. As alterações podem ser confirmadas com `COMMIT` ou desfeitas com `ROLLBACK`, desde que as tabelas utilizem um mecanismo transacional compatível.

## 7. Teste com COMMIT

**Objetivo:** demonstrar como confirmar uma alteração no preço de um produto.

```sql
START TRANSACTION;

UPDATE produto
SET preco = preco + 1.00
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

COMMIT;
```

**O que aconteceu após o COMMIT?**

O aumento de preço foi confirmado e passou a fazer parte dos dados persistidos. Em seguida, o script restaura o valor anterior em outra transação para não deixar a alteração de teste no banco.

## 8. Teste com ROLLBACK

**Verificação antes:**

```sql
SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;
```

**Operação executada:**

```sql
START TRANSACTION;

UPDATE produto
SET preco = preco + 100.00
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;

ROLLBACK;
```

**Verificação depois:**

```sql
SELECT id_produto, nome, preco
FROM produto
WHERE id_produto = 1;
```

**O que o ROLLBACK fez?**

Desfez a alteração não confirmada e restaurou o preço anterior ao início da transação.

## 9. Comparação COMMIT x ROLLBACK

### COMMIT

Confirma as alterações realizadas na transação.

### ROLLBACK

Desfaz as alterações ainda não confirmadas na transação.

### Por que transações são importantes?

Elas ajudam a manter a consistência dos dados, permitindo confirmar operações concluídas corretamente ou desfazer alterações quando ocorre algum problema.

## 10. Integração do Module-2

O arquivo `SPRINT5-5.sql` reúne:

1. Consultas com `JOIN`.
2. Subconsulta para comparar preços com a média.
3. Consultas às Views criadas na Sprint 3.
4. Execuções das Procedures e da Function da Sprint 4.
5. Criação e teste do Trigger.
6. Demonstração de `COMMIT` e `ROLLBACK`.
7. Consultas finais para validar os registros.

As rotinas anteriores devem estar criadas no banco antes de executar as consultas de integração.

## 11. Consulta relacional final

**Pergunta:** quais vendas foram realizadas, quais clientes fizeram as compras e quais funcionários foram responsáveis?

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

**Explicação:** a consulta utiliza `INNER JOIN` para relacionar vendas, clientes e funcionários, mostrando as informações em um único resultado.

## 12. Subconsulta final

**Pergunta:** quais produtos possuem preço acima da média dos produtos cadastrados?

```sql
SELECT id_produto, nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

**Explicação:** a subconsulta calcula a média dos preços. A consulta principal retorna somente os produtos que possuem preço maior que essa média.

## 13. VIEW final mais útil

**Nome:** `vw_vendas_resumo`

**Por que é importante?**

Ela reúne informações das vendas e calcula a quantidade de itens e o valor total, facilitando consultas sem precisar escrever toda a lógica novamente.

## 14. Procedure final mais útil

**Nome:** `sp_listar_vendas_cliente`

**Entrada:** identificador do cliente (`p_id_cliente`).

**Resultado:** lista as vendas do cliente informado, com data, status e funcionário responsável.

## 15. Function final

**Nome:** `fn_total_venda`

**O que retorna?**

Retorna o valor total dos itens de uma venda, calculado pela multiplicação da quantidade pelo preço unitário de cada item.

## 16. Trigger final

**Nome:** `trg_validar_preco_produto`

**Regra automatizada:** impede a atualização de um produto quando o novo preço é zero ou negativo.

## 17. Teste operacional final

- [ ] JOINs funcionam.
- [ ] Subconsultas funcionam.
- [ ] Views funcionam.
- [ ] Procedures funcionam.
- [ ] Function funciona.
- [ ] Trigger funciona.
- [ ] COMMIT funciona.
- [ ] ROLLBACK funciona.

## 18. Validação prática/oral

A consulta escolhida para explicação é a consulta relacional final, que utiliza `JOIN` para relacionar três tabelas.

Também é possível demonstrar a alteração de um parâmetro de Procedure, explicar a View `vw_vendas_resumo`, testar o Trigger com um preço inválido e demonstrar o funcionamento das transações.

## 19. Problemas encontrados

| Problema possível | Causa | Solução |
|---|---|---|
| Erro ao criar o Trigger | Sintaxe ou delimitador incorreto | Conferir o bloco `DELIMITER` |
| Rotina não encontrada | Sprint anterior não executada | Criar as rotinas anteriores antes da integração |
| ROLLBACK não desfaz a alteração | Tabela sem suporte transacional | Verificar se utiliza InnoDB |
| Produto não encontrado | ID usado no teste não existe | Selecionar um ID cadastrado |

## 20. Autoavaliação

**Conteúdo que compreendi melhor:**

Compreendi melhor como relacionar tabelas usando `JOIN` e reutilizar consultas com Views e Procedures.

**Conteúdo mais difícil:**

A parte mais difícil foi compreender o funcionamento dos Triggers e das transações.

**Código do Module-2 que considero mais importante:**

Considero importante a Function que calcula o total de uma venda, pois ela permite reutilizar o cálculo em diferentes consultas.

**O que eu conseguiria explicar presencialmente sem consultar material?**

Consigo explicar a diferença entre `COMMIT` e `ROLLBACK`, o funcionamento de um `JOIN` e a finalidade de uma Procedure.

*Revise essas respostas para que representem o que você realmente compreendeu.*

## 21. Estrutura do arquivo SQL

O arquivo `SPRINT5-5.sql` contém as consultas de integração, a criação do Trigger, os testes de transação e as consultas finais de validação.

## 22. Arquivos esperados no Module-2

```text
Module-2/
├── SPRINT1-5.md
├── SPRINT1-5.sql
├── SPRINT2-5.md
├── SPRINT2-5.sql
├── SPRINT3-5.md
├── SPRINT3-5.sql
├── SPRINT4-5.md
├── SPRINT4-5.sql
├── SPRINT5-5.md
└── SPRINT5-5.sql
```

Total esperado: **10 arquivos**.

## 23. Checklist final

- [ ] Mantive os arquivos do Module-1.
- [ ] Utilizei a mesma branch `team-XX`.
- [ ] Concluí as cinco Sprints do Module-2.
- [ ] Revisei os arquivos `.md` e `.sql`.
- [ ] Executei e validei as consultas.
- [ ] Testei o Trigger.
- [ ] Demonstrei COMMIT e ROLLBACK.
- [ ] Conferi os nomes dos arquivos e suas pastas.
- [ ] Estou preparado para explicar o código entregue.

## 24. Commit da Sprint 5/5

```text
Conclui Module 2 Sprint 5 de 5 - triggers e transacoes
```

## 25. Pull Request final do Module-2

**Origem:** `team-XX`  
**Destino:** `main`

Título para UFR:

```text
[N2][UFR][Team XX] Sprints 1-5 - db_mercado
```

Substituir `XX` pelo número real da equipe, conforme o repositório.

## 26. Descrição sugerida do Pull Request

```text
## Identificação

Aluno: Matheus Bessa Machado
Instituição: UFR
Branch: team-XX
Banco: db_mercado
Módulo: 2

## Arquivos entregues

- Module-2/SPRINT1-5.md
- Module-2/SPRINT1-5.sql
- Module-2/SPRINT2-5.md
- Module-2/SPRINT2-5.sql
- Module-2/SPRINT3-5.md
- Module-2/SPRINT3-5.sql
- Module-2/SPRINT4-5.md
- Module-2/SPRINT4-5.sql
- Module-2/SPRINT5-5.md
- Module-2/SPRINT5-5.sql

## Validação

- [ ] JOINs testados
- [ ] Subconsultas testadas
- [ ] Views testadas
- [ ] Procedures testadas
- [ ] Function testada
- [ ] Trigger testado
- [ ] COMMIT testado
- [ ] ROLLBACK testado
```

## 27. Uso de LLMs

A inteligência artificial foi utilizada como apoio para estruturar e compreender o código. Todas as rotinas devem ser adaptadas ao esquema real, executadas e testadas no MySQL Workbench.

**Fluxo:** Compreender → Adaptar → Executar → Testar → Validar.

## Critério de conclusão do Module-2

O módulo será considerado concluído após a entrega das cinco Sprints, a validação dos dez arquivos, a execução dos testes e a abertura do Pull Request final.
