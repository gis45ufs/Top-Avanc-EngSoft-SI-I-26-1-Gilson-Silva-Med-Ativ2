# Atividade 2 — LLM-as-a-Judge com PostgreSQL no Domínio Médico

Implementação da **Atividade 2** da disciplina **Tópicos Avançados em Engenharia de Software e SI I**, com foco no paradigma **LLM-as-a-Judge** e persistência em **PostgreSQL** no **domínio médico**.

## Objetivo

Transformar os artefatos produzidos na Atividade 1 em uma infraestrutura auditável, reproduzível e escalável, capaz de:

- armazenar datasets e respostas em banco relacional;
- registrar avaliações humanas e avaliações do Juiz-IA;
- persistir o `reasoning` e a `score` do juiz;
- analisar a concordância entre juiz e avaliação humana com **correlação de Spearman**;
- permitir auditoria e restore local do experimento.

## Domínio e datasets

### Domínio
- Médico

### Datasets
- **K-QA** — questões abertas
- **USMLE com gabarito** — questões de múltipla escolha

## Relação com a Atividade 1

Esta atividade reutiliza os artefatos da Atividade 1, especialmente:

- curadoria das questões abertas;
- curadoria das questões de múltipla escolha;
- respostas dos modelos candidatos;
- avaliação humana/manual estruturada das respostas abertas.

## Escopo reaproveitado

No recorte individual que serviu de base para esta implementação:

- **questões abertas:** 86 a 100
- **questões de múltipla escolha:** 136 a 162

## Modelos candidatos

Os modelos candidatos originalmente avaliados foram:

- GPT-5.4 Thinking
- Claude 4.6 Sonnet
- Gemini 3.0

## Modelo juiz

O modelo juiz utilizado nesta atividade deve ser registrado na tabela `modelos` com papel `juiz`.

Exemplo:
- `JUDGE_MODEL`

## Estrutura do projeto

```text
Atividade_2/
├── README.md
├── .env.example
├── data/
│   ├── dataset.json
│   ├── questions_w_answers.jsonl
│   ├── usmle_questions.json
│   ├── curadoria_abertas.csv
│   ├── curadoria_mc.csv
│   ├── respostas_llms.csv
│   └── avaliacao_llms.csv
├── prompts/
│   └── juiz_medico_en.txt
├── sql/
│   ├── 01_schema.sql
│   ├── 02_seed.sql
│   └── 03_queries_analise.sql
├── scripts/
│   ├── etl_atividade2.py
│   ├── executar_juiz.py
│   └── calcular_correlacao.py
├── outputs/
│   ├── avaliacoes_juiz.csv
│   ├── pares_humano_vs_juiz.csv
│   ├── correlacao_spearman.csv
│   └── analise_erros.csv
├── backup/
│   └── backup_atividade_2.sql
└── tutorial/
    ├── Tutorial_Atividade_2.tex
    └── Tutorial_Atividade_2.pdf
```

## Banco de dados

A modelagem relacional foi organizada para registrar:

- datasets;
- perguntas e resposta ouro;
- alternativas das múltipla escolha;
- respostas da Atividade 1;
- avaliações humanas da Atividade 1;
- avaliações do Juiz-IA.

### Tabelas principais
- `modelos`
- `datasets`
- `perguntas`
- `alternativas`
- `respostas_atividade_1`
- `avaliacoes_humanas_atividade_1`
- `avaliacoes_juiz`

## Rubrica do Juiz-IA

A rubrica médica utiliza escala de **1 a 5**, priorizando segurança clínica acima da fluidez textual.

- **1**: erro crítico / conduta perigosa / dosagem incorreta
- **2**: parcialmente correta, mas com omissões graves
- **3**: correta, porém incompleta
- **4**: muito boa, clinicamente adequada
- **5**: excelente, segura e altamente alinhada ao padrão-ouro

## Prompt do Juiz

O prompt do Juiz-IA foi mantido em inglês no domínio médico.

Arquivo:
- `prompts/juiz_medico_en.txt`

Saída esperada:
- `REASONING: ...`
- `SCORE: 1 a 5`

## Fluxo do pipeline

1. carregar os artefatos da Atividade 1;
2. popular o PostgreSQL com ETL;
3. executar o Juiz-IA sobre as respostas candidatas;
4. salvar `reasoning` e `score`;
5. extrair pares humano vs juiz;
6. calcular correlação de Spearman;
7. gerar outputs, backup e documentação.

## Como executar

### 1. Criar o banco

```bash
createdb -U postgres atividade2_med
```

### 2. Criar o schema

```bash
psql -U postgres -d atividade2_med -f sql/01_schema.sql
```

### 3. Inserir datasets e modelos

```bash
psql -U postgres -d atividade2_med -f sql/02_seed.sql
```

### 4. Executar ETL

```bash
python scripts/etl_atividade2.py
```

### 5. Executar o Juiz-IA

```bash
python scripts/executar_juiz.py --backend mock
```

> Observação: o backend `mock` é útil para validar o pipeline sem depender de API externa. Para produção, a equipe deve implementar a chamada real ao modelo juiz escolhido.

### 6. Calcular correlação

```bash
python scripts/calcular_correlacao.py
```

## Outputs esperados

Na pasta `outputs/`, o experimento deve gerar:

- `avaliacoes_juiz.csv`
- `pares_humano_vs_juiz.csv`
- `correlacao_spearman.csv`
- `analise_erros.csv`

## Conversão da avaliação humana

Como a Atividade 1 usou escala total de 0 a 10 e a Atividade 2 usa escala de 1 a 5, foi adotada a seguinte regra:

- 9–10 → 5
- 7–8 → 4
- 5–6 → 3
- 3–4 → 2
- 0–2 → 1

Essa conversão deve ser explicitada no tutorial e no relatório final.

## Restore do banco

Para recriar o ambiente local a partir do backup:

```bash
psql -U postgres -d atividade2_med -f backup/backup_atividade_2.sql
```

## Backup

Exemplo de geração do backup:

```bash
pg_dump -U postgres -d atividade2_med -f backup/backup_atividade_2.sql
```

## Links importantes

### Vídeo da apresentação
- [Adicionar link do vídeo aqui]

### Tutorial em PDF
- `tutorial/Tutorial_Atividade_2.pdf`

## Observação metodológica importante

No recorte individual que originou esta base:

- as **questões abertas** já possuem respostas candidatas e avaliação humana/manual;
- as **questões de múltipla escolha** já estão curadas e estruturadas, mas sua inclusão no pipeline do juiz depende da existência de respostas candidatas reais.

Essa decisão preserva coerência entre documentação e evidência experimental.

## Referências

- K-QA: *A Real World Medical Q&A Benchmark*
- USMLE com gabarito
- Materiais da disciplina sobre benchmark e LLM-as-a-Judge
- Fontes clínicas registradas nos artefatos da Atividade 1

## Declaração

Este repositório foi organizado para atender aos requisitos da Atividade 2 com foco em rastreabilidade, reprodutibilidade, auditoria e alinhamento ao escopo efetivamente executado na Atividade 1.
