# Dicionário de Dados

Este documento descreve a tabela limpa `supply_chain`, criada em [`sql/02_limpeza.sql`](sql/02_limpeza.sql) a partir do arquivo original [`data/supply_chain_data.csv`](data/supply_chain_data.csv).

- **Linhas:** 100 (uma por produto/SKU)
- **Colunas:** 24
- **Padrão de nomes:** português, letras minúsculas e palavras separadas por `_` (snake_case)
- **Arredondamento:** valores monetários e taxas com 2 casas decimais

O dataset original não tem documentação oficial. Os significados abaixo foram interpretados a partir dos nomes e dos valores das colunas. As interpretações marcadas como **suposição** devem ser lidas com cautela.

A coluna **Usada em** indica em qual pergunta de negócio a coluna aparece (P1, P2 ou P3). Colunas marcadas com "—" foram mantidas na tabela, mas não entraram nas análises.

## Produto e vendas

| Coluna | Coluna original | Descrição | Tipo | Usada em |
|---|---|---|---|---|
| `tipo_produto` | Product type | Categoria do produto: skincare, haircare ou cosmetics | texto | P1 |
| `sku` | SKU | Código único do produto (*Stock Keeping Unit*) | texto | — |
| `preco` | Price | Preço de venda de uma unidade | decimal | — |
| `unidades_vendidas` | Number of products sold | Unidades vendidas | inteiro | P1 |
| `receita` | Revenue generated | Receita total do produto | decimal | P1 |
| `genero_cliente` | Customer demographics | Perfil de gênero predominante do cliente | texto | — |

## Estoque e pedidos

| Coluna | Coluna original | Descrição | Tipo | Usada em |
|---|---|---|---|---|
| `disponibilidade` | Availability | Índice de disponibilidade de 0 a 100 (**suposição**) | inteiro | — |
| `nivel_estoque` | Stock levels | Unidades em estoque | inteiro | — |
| `qtd_pedida` | Order quantities | Quantidade de um pedido típico (**suposição**) | inteiro | — |
| `lead_time_pedido` | Lead times | Dias do pedido até o produto chegar ao estoque (**suposição**) | inteiro | — |

## Logística

| Coluna | Coluna original | Descrição | Tipo | Usada em |
|---|---|---|---|---|
| `transportadora` | Shipping carriers | Transportadora responsável | texto | P3 |
| `modal_transporte` | Transportation modes | Modal de transporte | texto | P3 |
| `rota` | Routes | Rota utilizada | texto | — |
| `tempo_envio_dias` | Shipping times | Tempo de envio, em dias | inteiro | P3 |
| `custo_envio` | Shipping costs | Custo do frete | decimal | P3 |
| `custo_logistico` | Costs | Custo logístico total (**suposição**) | decimal | — |

## Fornecedor e produção

| Coluna | Coluna original | Descrição | Tipo | Usada em |
|---|---|---|---|---|
| `fornecedor` | Supplier name | Nome do fornecedor | texto | P2 |
| `cidade` | Location | Cidade do fornecedor | texto | — |
| `lead_time_fornecedor` | Lead time | Prazo de entrega do fornecedor, em dias (**suposição**) | inteiro | P2 |
| `volume_producao` | Production volumes | Quantidade produzida | inteiro | — |
| `lead_time_fabricacao` | Manufacturing lead time | Tempo de fabricação, em dias | inteiro | — |
| `custo_fabricacao` | Manufacturing costs | Custo de fabricação | decimal | P2 |

## Qualidade

| Coluna | Coluna original | Descrição | Tipo | Usada em |
|---|---|---|---|---|
| `resultado_inspecao` | Inspection results | Resultado da inspeção de qualidade | texto | P2 |
| `taxa_defeitos` | Defect rates | Taxa de defeitos, em % (valores entre 0 e 5) | decimal | P2 |

## Valores das colunas de categoria

Quantidade de produtos em cada valor, conferida na consulta 5 de `02_limpeza.sql`.

| Coluna | Valores (quantidade de produtos) |
|---|---|
| `tipo_produto` | skincare (40), haircare (34), cosmetics (26) |
| `transportadora` | Carrier A (28), Carrier B (43), Carrier C (29) |
| `modal_transporte` | Road (29), Rail (28), Air (26), Sea (17) |
| `resultado_inspecao` | Pending (41), Fail (36), Pass (23) |
| `fornecedor` | Supplier 1 (27), Supplier 2 (22), Supplier 3 (15), Supplier 4 (18), Supplier 5 (18) |
| `cidade` | Kolkata (25), Mumbai (22), Chennai (20), Bangalore (18), Delhi (15) |
| `genero_cliente` | Female, Male, Non-binary, Unknown |
| `rota` | Route A, Route B, Route C |

## Observações

- **Duas colunas de lead time no original:** `Lead times` e `Lead time` têm nomes quase idênticos, mas valores diferentes. Por isso foram renomeadas para `lead_time_pedido` e `lead_time_fornecedor`, deixando explícita a interpretação adotada.
- **Receita:** os valores de `receita` não correspondem a `preco` × `unidades_vendidas`, o que indica dados sintéticos. As análises usam a receita como ela foi informada.
- **Importação:** ao importar o CSV, o SQLite Online trocou os espaços dos nomes por `_` e cortou os nomes em 16 caracteres (ex.: `Revenue generated` virou `revenue_generate`). A tabela limpa corrige isso com os novos nomes.
