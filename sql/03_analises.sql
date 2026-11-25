-- Etapa 3: Perguntas de Negócio

-- Pergunta 1: Qual tipo de produto gera mais receita e qual tem o melhor ticket médio?

-- 1. Receita total por tipo de produtod
SELECT
	tipo_produto,
    COUNT(*) AS qtd_produtos,
    SUM(unidades_vendidas) AS unidades_vendidas,
    ROUND(SUM(receita), 2) AS receita_total
FROM supply_chain
GROUP BY tipo_produto
ORDER BY receita_total DESC;


-- 2. Receita por produto, ticket médio por unidade e participação na receita total
SELECT
	tipo_produto,
    ROUND(SUM(receita) / COUNT(*), 2) AS receita_por_produto,
    ROUND(SUM(receita) / SUM(unidades_vendidas), 2) AS ticket_medio,
    ROUND(SUM(receita) * 100.0 / (SELECT SUM(receita) FROM supply_chain), 2) as participacao_pct
from supply_chain
GROUP by tipo_produto
order by ticket_medio DESC;


-- Pergunta 2: Qual fornecedor entrega a melhor qualidade?

-- 3. Qualidade, custo e prazo por fornecedor

SELECT
	fornecedor,
    COUNT(*) AS qtd_produtos,
    ROUND(AVG(taxa_defeitos), 2) AS taxa_defeitos_media,
    ROUND(SUM(CASE WHEN resultado_inspecao = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_aprovados,   
    ROUND(SUM(CASE WHEN resultado_inspecao = 'Fail' Then 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_reprovados,
    ROUND(SUM(CASE WHEN resultado_inspecao = 'Pending' THEN 1 ELSE 0  END) * 100.0 / COUNT(*), 2) AS pct_pendentes,
    ROUND(AVG(custo_fabricacao), 2) AS custo_fabricacao_medio,
    ROUND(AVG(lead_time_fornecedor), 2) AS lead_time_fornecedor_medio
from supply_chain
group by fornecedor
ORDER BY taxa_defeitos ASC;


-- 4. Ranking geral dos fornecedores nos quatro critérios
WITH metricas AS (
	SELECT
		fornecedor,
		AVG(taxa_defeitos) AS taxa_defeitos_media,
		SUM(CASE WHEN resultado_inspecao = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS pct_aprovados,
		AVG(custo_fabricacao) AS custo_fabricacao_medio,
		AVG(lead_time_fornecedor) AS lead_time_fornecedor_medio
	FROM supply_chain
	GROUP BY fornecedor
),
rankings AS (
	SELECT
		fornecedor,
		RANK() OVER (ORDER BY taxa_defeitos_media ASC) AS pos_defeitos,
		RANK() OVER (ORDER BY pct_aprovados DESC) AS pos_aprovacao,
		RANK() OVER (ORDER BY custo_fabricacao_medio ASC) AS pos_custo,
		RANK() OVER (ORDER BY lead_time_fornecedor_medio ASC) AS pos_prazo
	FROM metricas
)
SELECT
	fornecedor,
	pos_defeitos,
	pos_aprovacao,
	pos_custo,
	pos_prazo,
	pos_defeitos + pos_aprovacao + pos_custo + pos_prazo AS pontuacao,
	RANK() OVER (ORDER BY pos_defeitos + pos_aprovacao + pos_custo + pos_prazo ASC) AS ranking_geral
FROM rankings
ORDER BY ranking_geral;


-- Pergunta 3: Qual transportadora e qual modal equilibram custo e prazo?

-- 5. Custo e prazo médios por transportadora
SELECT
	transportadora,
	COUNT(*) AS qtd_produtos,
	ROUND(AVG(custo_envio), 2) AS custo_envio_medio,
	ROUND(AVG(tempo_envio_dias), 2) AS tempo_envio_medio
FROM supply_chain
GROUP BY transportadora
ORDER BY custo_envio_medio ASC;


-- 6. Custo e prazo médios por modal de transporte
SELECT
	modal_transporte,
	COUNT(*) AS qtd_produtos,
	ROUND(AVG(custo_envio), 2) AS custo_envio_medio,
	ROUND(AVG(tempo_envio_dias), 2) AS tempo_envio_medio
FROM supply_chain
GROUP BY modal_transporte
ORDER BY custo_envio_medio ASC;


-- 7. Custo e prazo por combinação de transportadora + modal (análise complementar)

SELECT
	transportadora,
	modal_transporte,
	COUNT(*) AS qtd_produtos,
	ROUND(AVG(custo_envio), 2) AS custo_envio_medio,
	ROUND(AVG(tempo_envio_dias), 2) AS tempo_envio_medio
FROM supply_chain
GROUP BY transportadora, modal_transporte
ORDER BY custo_envio_medio ASC;