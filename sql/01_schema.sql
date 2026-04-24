BEGIN;

CREATE TABLE IF NOT EXISTS modelos (
    id_modelo SERIAL PRIMARY KEY,
    nome_modelo VARCHAR(100) NOT NULL UNIQUE,
    versao VARCHAR(50),
    papel VARCHAR(20) NOT NULL CHECK (papel IN ('candidato', 'juiz')),
    parametro_precisao VARCHAR(20),
    observacoes TEXT
);

CREATE TABLE IF NOT EXISTS datasets (
    id_dataset SERIAL PRIMARY KEY,
    nome_dataset VARCHAR(100) NOT NULL UNIQUE,
    dominio VARCHAR(50) NOT NULL,
    tipo_questao VARCHAR(30) NOT NULL CHECK (tipo_questao IN ('aberta', 'multipla_escolha'))
);

CREATE TABLE IF NOT EXISTS perguntas (
    id_pergunta SERIAL PRIMARY KEY,
    id_dataset INTEGER NOT NULL REFERENCES datasets(id_dataset),
    official_id INTEGER NOT NULL,
    enunciado TEXT NOT NULL,
    resposta_ouro TEXT NOT NULL,
    metadados JSONB NOT NULL DEFAULT '{}'::jsonb,
    UNIQUE (id_dataset, official_id)
);

CREATE TABLE IF NOT EXISTS alternativas (
    id_alternativa SERIAL PRIMARY KEY,
    id_pergunta INTEGER NOT NULL REFERENCES perguntas(id_pergunta) ON DELETE CASCADE,
    letra VARCHAR(2) NOT NULL,
    texto TEXT NOT NULL,
    is_correta BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (id_pergunta, letra)
);

CREATE TABLE IF NOT EXISTS respostas_atividade_1 (
    id_resposta SERIAL PRIMARY KEY,
    id_pergunta INTEGER NOT NULL REFERENCES perguntas(id_pergunta) ON DELETE CASCADE,
    id_modelo INTEGER NOT NULL REFERENCES modelos(id_modelo),
    texto_resposta TEXT NOT NULL,
    tempo_inferencia_ms DOUBLE PRECISION,
    data_geracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    origem VARCHAR(50) NOT NULL DEFAULT 'atividade_1',
    UNIQUE (id_pergunta, id_modelo, origem)
);

CREATE TABLE IF NOT EXISTS avaliacoes_humanas_atividade_1 (
    id_avaliacao_humana SERIAL PRIMARY KEY,
    id_resposta_ativa1 INTEGER NOT NULL REFERENCES respostas_atividade_1(id_resposta) ON DELETE CASCADE,
    clinical_correctness_0_2 SMALLINT CHECK (clinical_correctness_0_2 BETWEEN 0 AND 2),
    completeness_0_2 SMALLINT CHECK (completeness_0_2 BETWEEN 0 AND 2),
    alignment_with_gold_0_2 SMALLINT CHECK (alignment_with_gold_0_2 BETWEEN 0 AND 2),
    safety_0_2 SMALLINT CHECK (safety_0_2 BETWEEN 0 AND 2),
    clarity_0_2 SMALLINT CHECK (clarity_0_2 BETWEEN 0 AND 2),
    total_score_0_10 SMALLINT CHECK (total_score_0_10 BETWEEN 0 AND 10),
    nota_humana_1a5 SMALLINT CHECK (nota_humana_1a5 BETWEEN 1 AND 5),
    comentarios TEXT,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_resposta_ativa1)
);

CREATE TABLE IF NOT EXISTS avaliacoes_juiz (
    id_avaliacao SERIAL PRIMARY KEY,
    id_resposta_ativa1 INTEGER NOT NULL REFERENCES respostas_atividade_1(id_resposta) ON DELETE CASCADE,
    id_modelo_juiz INTEGER NOT NULL REFERENCES modelos(id_modelo),
    nota_atribuida SMALLINT NOT NULL CHECK (nota_atribuida BETWEEN 1 AND 5),
    chain_of_thought TEXT NOT NULL,
    data_avaliacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_resposta_ativa1, id_modelo_juiz)
);

CREATE INDEX IF NOT EXISTS idx_perguntas_dataset ON perguntas(id_dataset);
CREATE INDEX IF NOT EXISTS idx_respostas_pergunta ON respostas_atividade_1(id_pergunta);
CREATE INDEX IF NOT EXISTS idx_respostas_modelo ON respostas_atividade_1(id_modelo);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_juiz_resposta ON avaliacoes_juiz(id_resposta_ativa1);
CREATE INDEX IF NOT EXISTS idx_avaliacoes_humanas_resposta ON avaliacoes_humanas_atividade_1(id_resposta_ativa1);

COMMIT;
