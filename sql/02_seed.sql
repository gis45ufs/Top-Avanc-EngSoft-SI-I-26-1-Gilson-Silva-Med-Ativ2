INSERT INTO datasets (nome_dataset, dominio, tipo_questao)
VALUES
    ('K-QA', 'Medico', 'aberta'),
    ('USMLE', 'Medico', 'multipla_escolha')
ON CONFLICT (nome_dataset) DO NOTHING;

INSERT INTO modelos (nome_modelo, versao, papel, parametro_precisao, observacoes)
VALUES
    ('GPT-5.4 Thinking', NULL, 'candidato', 'N/A', 'Modelo candidato da Atividade 1'),
    ('Claude 4.6 Sonnet', NULL, 'candidato', 'N/A', 'Modelo candidato da Atividade 1'),
    ('Gemini 3.0', NULL, 'candidato', 'N/A', 'Modelo candidato da Atividade 1'),
    ('JUDGE_MODEL', NULL, 'juiz', 'N/A', 'Substituir pelo modelo juiz escolhido pela equipe')
ON CONFLICT (nome_modelo) DO NOTHING;
