-- Etapa 2: Limpeza dos Dados
-- 1. Inspecionar a consulta ta tabela bruta
PRAGMA table_info(supply_chain_raw);


--2. Procurar se há valores SKU's duplicados
SELECT sku,
	   COUNT(*) AS ocorrencias
FROM supply_chain_raw     
GROUP BY sku
HAVING COUNT(*) > 1;


-- 3. Procurar valores nulos ou vazos nas colunas principais, que servirão como guia das perguntas de negócio
SELECT
	SUM(CASE WHEN product_type IS NULL OR product_type = '' THEN 1 ELSE 0 END) AS nulos_tipo_produto,
    SUM(CASE WHEN price IS NULL OR  price = '' THEN 1 ELSE 0 END) AS nulos_preco,
    SUM(CASE WHEN revenue_generate IS NULL OR revenue_generate = '' THEN 1 ELSE 0 END) AS nulos_receita,
    SUM(CASE WHEN stock_levels IS NULL OR stock_levels = '' THEN 1 ELSE 0 END) AS nulos_estoque,
    SUM(CASE WHEN supplier_name IS NULL OR supplier_name = '' THEN 1 ELSE 0 END) AS nulos_fornecedor,
    SUM(CASE WHEN shipping_carrier IS NULL OR shipping_carrier = '' THEN 1 ELSE 0 END) AS nulo_transportadora,
    SUM(CASE WHEN defect_rates IS NULL OR defect_rates = '' THEN 1 ELSE 0 END) AS nulos_defeitos,
    SUM(CASE WHEN location IS NULL OR location = '' THEN 1 ELSE 0 END) AS nulos_cidade
FROM supply_chain_raw;    


-- 4. Checar se os valores gerais são válidos
SELECT
	MIN(price) AS preco_min,
    MAX(price) AS preco_max,
    ROUND(AVG(price), 2) AS preco_medio,
    MIN(revenue_generate) as receita_min,
    MAX(revenue_generate) AS receita_max,
    ROUND(AVG(revenue_generate)) AS recieta_media,
    MIN(stock_levels) AS estoque_min,
    MAX(stock_levels) AS estoque_max,
    MIN(defect_rates) AS defeitos_min,
    MAX(defect_rates) AS defeitos_max,
    MIN(shipping_costs) AS custo_envio_min,
    MAX(shipping_costs) AS custo_envio_max
FROM supply_chain_raw  


-- 5. Conferir se há categorias diferentes pelo simples fato de haver erros de grafia. Ex: "Road" e "road"
SELECT 'transportadora' AS coluna, shipping_carrier AS VALOR, COUNT(*) AS qtd
FROM supply_chain_raw
GROUP BY shipping_carrier

UNION ALL

SELECT 'modal', transportation_m, COUNT(*)
FROM supply_chain_raw
GROUP BY transportation_m

UNION ALL

SELECT 'inspecao', inspection_resul, COUNT(*)
FROM supply_chain_raw
GROUP BY inspection_resul

UNION ALL

SELECT 'cidade', location, COUNT(*)
FROM supply_chain_raw
GROUP BY location

UNION ALL

SELECT 'fornecedor', supplier_name, COUNT(*)
FROM supply_chain_raw
GROUP BY supplier_name

ORDER BY coluna, valor;


-- 6. Criar a nova tabela limpa
DROP TABLE IF EXISTS supply_chain;

CREATE TABLE supply_chain AS
SELECT
      product_type AS tipo_produto,
      sku AS sku,
      ROUND(price, 2) AS preco,
      availability AS disponibilidade,
      number_of_produc AS unidades_vendidas,
      ROUND(revenue_generate, 2) AS receita,
      customer_demogra AS genero_cliente,
      stock_levels AS nivel_estoque,
      lead_times AS lead_time_pedido,
      order_quantities as qtd_pedida,
      shipping_times AS tempo_envio_dias,
      shipping_carrier AS transportadora,
      ROUND(shipping_costs, 2) AS custo_envio,
      supplier_name AS fornecedor,
      location AS cidade,
      lead_time AS lead_time_fornecedor,
      production_volum AS volume_producao,
      manufacturing_le AS lead_time_fabricacao,
      ROUND(manufacturing_co, 2) AS custo_fabricacao,
      inspection_resul AS resultado_inspecao,
      ROUND(defect_rates, 2) AS taxa_defeitos,
      transportation_m AS modal_transporte,
      routes AS rota,
      ROUND(costs, 2) AS custo_logistico
FROM supply_chain_raw;    


-- 7. Validar a atbela limpa comparando com a tabela original
SELECT
	(SELECT COUNT(*) FROM supply_chain_raw) AS linhas_brutas,
    (SELECT COUNT(*) FROM supply_chain) as linhas_limpas,
    (SELECT ROUND(SUM(revenue_generate), 2) FROM supply_chain_raw) AS receita_bruta,
    (SELECT ROUND(SUM(receita), 2) FROM supply_chain) AS receita_limpa;
    


    
    
