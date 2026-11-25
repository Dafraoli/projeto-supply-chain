-- Projeto: Análise de Sypply Chain
-- ETAPA 1: Exploração inicial dos dados

-- 1. Ver nome e tipos de colunas através do PRAGMA
PRAGMA table_info(supply_chain_raw);

-- 2. Ver as 5 primeiras linhas da tabela
SELECT * FROM supply_chain_raw
LIMIT 5;

-- 3. Quantas linhas há na tabela?
SELECT COUNT(*) AS total_linhas
FROM supply_chain_raw;

-- 4. Há SKUs suplicados?
SELECT COUNT(DISTINCT sku) AS skus_unicos
FROM supply_chain_raw;

-- 5. Quantidade de itens por categoria
SELECT "Product_type" as tipos_de_produto,
        COUNT(*)      As qtde_produto
FROM supply_chain_raw
GROUP BY "Product_type"
ORDER BY qtde_produto DESC;
        