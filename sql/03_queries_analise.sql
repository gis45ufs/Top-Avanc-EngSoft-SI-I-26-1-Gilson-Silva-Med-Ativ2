-- 1) Quantidade de perguntas por dataset
SELECT d.nome_dataset, COUNT(*) AS total_perguntas
FROM perguntas p
JOIN datasets d ON p.id_dataset = d.id_dataset
GROUP BY d.nome_dataset
ORDER BY d.nome_dataset;

-- 2) Quantidade de respostas por modelo candidato
SELECT m.nome_modelo, COUNT(*) AS total_respostas
FROM respostas_atividade_1 r
JOIN modelos m ON r.id_modelo = m.id_modelo
GROUP BY m.nome_modelo
ORDER BY total_respostas DESC;

-- 3) Média das notas do juiz por modelo candidato
SELECT
    m_cand.nome_modelo AS modelo_candidato,
    m_juiz.nome_modelo AS modelo_juiz,
    AVG(a.nota_atribuida) AS media_juiz,
    COUNT(*) AS total_julgado
FROM avaliacoes_juiz a
JOIN respostas_atividade_1 r ON a.id_resposta_ativa1 = r.id_resposta
JOIN modelos m_cand ON r.id_modelo = m_cand.id_modelo
JOIN modelos m_juiz ON a.id_modelo_juiz = m_juiz.id_modelo
GROUP BY m_cand.nome_modelo, m_juiz.nome_modelo
ORDER BY m_cand.nome_modelo, m_juiz.nome_modelo;

-- 4) Pares humano vs juiz para Spearman
SELECT
    p.official_id,
    d.nome_dataset,
    m_cand.nome_modelo AS modelo_candidato,
    m_juiz.nome_modelo AS modelo_juiz,
    ah.nota_humana_1a5,
    a.nota_atribuida AS nota_juiz
FROM avaliacoes_juiz a
JOIN respostas_atividade_1 r ON a.id_resposta_ativa1 = r.id_resposta
JOIN perguntas p ON r.id_pergunta = p.id_pergunta
JOIN datasets d ON p.id_dataset = d.id_dataset
JOIN modelos m_cand ON r.id_modelo = m_cand.id_modelo
JOIN modelos m_juiz ON a.id_modelo_juiz = m_juiz.id_modelo
LEFT JOIN avaliacoes_humanas_atividade_1 ah ON ah.id_resposta_ativa1 = r.id_resposta
WHERE ah.nota_humana_1a5 IS NOT NULL
ORDER BY p.official_id, m_cand.nome_modelo;

-- 5) Casos em que o juiz deu nota alta para resposta com nota humana baixa
SELECT
    p.official_id,
    m_cand.nome_modelo AS modelo_candidato,
    a.nota_atribuida,
    ah.nota_humana_1a5,
    r.texto_resposta,
    a.chain_of_thought
FROM avaliacoes_juiz a
JOIN respostas_atividade_1 r ON a.id_resposta_ativa1 = r.id_resposta
JOIN perguntas p ON r.id_pergunta = p.id_pergunta
JOIN modelos m_cand ON r.id_modelo = m_cand.id_modelo
LEFT JOIN avaliacoes_humanas_atividade_1 ah ON ah.id_resposta_ativa1 = r.id_resposta
WHERE ah.nota_humana_1a5 IS NOT NULL
  AND ah.nota_humana_1a5 <= 2
  AND a.nota_atribuida >= 4
ORDER BY p.official_id, m_cand.nome_modelo;
