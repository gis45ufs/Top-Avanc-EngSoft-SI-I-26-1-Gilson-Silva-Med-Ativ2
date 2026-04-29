# 🏥 Atividade 2 — LLM-as-a-Judge com PostgreSQL no Domínio Médico

> **🚀 Demonstração ao Vivo:** Acesse o **[Medical Judge Explorer](https://medical-judge-explorer.vercel.app/)** para interagir com o dashboard visual que consolida os dados e insights gerados por esta arquitetura.

| Informação Acadêmica | Detalhes |
| :--- | :--- |
| **Discente** | Gilson Inácio da Silva |
| **Matrícula** | 202611005730 |
| **Programa** | Pós-Graduação em Ciência da Computação |
| **Disciplina** | Tópicos Avançados em Engenharia de Software e SI I |
| **Equipe** | Equipe 2 - Medicina |

---

## 🎯 Sobre o Projeto e Objetivos

Esta é a implementação final da **Atividade 2**. O projeto consolida a transição de um modelo de avaliações heurísticas para um framework robusto de auditoria semântica, utilizando o paradigma **LLM-as-a-Judge** com persistência em banco de dados relacional.

O objetivo central desta etapa foi transformar os artefatos experimentais produzidos na [Atividade 1](https://github.com/gis45ufs/Top-Avanc-EngSoft-SI-I-26-1-Gilson-Inacio-Silva-Med-Ativ1) em uma infraestrutura auditável, rastreável e escalável, capaz de prover:

- **Persistência Relacional (PostgreSQL):** Modelagem e armazenamento de datasets, questões, respostas candidatas e logs de avaliação.
- **Auditoria Semântica Real:** Implementação do Medical Judge para avaliar criticamente a acurácia técnica, a segurança clínica e o alinhamento com o *Gold Standard*.
- **Transparência de Raciocínio:** Persistência estruturada das justificativas (o *reasoning*) geradas pelo Juiz, viabilizando futuras auditorias humanas.
- **Validação Estatística:** Cálculo de concordância metodológica entre avaliações humanas e de IA utilizando a **Correlação de Spearman**.
- **Engenharia de Dados (ETL):** Automatização do fluxo ponta a ponta (extração, avaliação e carga), com rotinas de backup e restore para garantir reprodutibilidade.

---

## 🏥 Domínio e Datasets

**Domínio:** Médico.

O projeto utiliza datasets derivados da Atividade 1, com foco em perguntas clínicas e respostas geradas por diferentes modelos de linguagem.

### Datasets utilizados

| Dataset | Tipo | Recorte utilizado |
|---|---|---|
| K-QA | Questões abertas | IDs 86 a 100 |
| USMLE | Questões de múltipla escolha com gabarito | IDs 136 a 162 |

### Arquivos de entrada na pasta `data/`

A pasta `data/` contém os arquivos originais e derivados da [Atividade 1](https://github.com/gis45ufs/Top-Avanc-EngSoft-SI-I-26-1-Gilson-Inacio-Silva-Med-Ativ1) utilizados como entrada para o ETL da Atividade 2:

| Arquivo | Finalidade |
|---|---|
| `avaliacao_llms.csv` | Avaliações humanas/curadas das respostas dos LLMs na Atividade 1 |
| `curadoria_abertas.csv` | Curadoria das questões abertas do dataset K-QA |
| `curadoria_mc.csv` | Curadoria das questões de múltipla escolha do dataset USMLE |
| `dataset.json` | Dataset base com questões abertas |
| `questions_w_answers.jsonl` | Questões com respostas de referência em formato JSONL |
| `respostas_llms.csv` | Respostas geradas pelos modelos candidatos |
| `usmle_questions.json` | Dataset de questões USMLE |

### Recorte efetivo da auditoria

O pipeline final foi executado sobre um recorte individual de **45 amostras**, composto por:

- **15 questões abertas K-QA**;
- respostas avaliadas para **3 modelos candidatos**;
- total de **45 respostas candidatas auditadas**;
- avaliação automatizada realizada por um juiz LLM neutro;
- remoção prévia de registros de teste/mock do banco de dados.

---

## 🤖 Arquitetura — Medical Judge

Diferente das versões iniciais que utilizavam um backend mock/teste, esta implementação utiliza um modelo de **Juiz Neutro** de alta capacidade.

| Item | Definição |
|---|---|
| Modelo juiz | `llama-3.3-70b-versatile` |
| Família | Llama 3.3 |
| Tamanho | 70 bilhões de parâmetros |
| Infraestrutura | API Cloud da Groq |
| Estratégia | Uso de modelo Open Weights para mitigar Self-Preference Bias |
| Temperatura | `0` |
| Objetivo | Garantir avaliações mais determinísticas, reprodutíveis e auditáveis |

A escolha por um juiz neutro busca reduzir o **Self-Preference Bias**, isto é, a tendência de um modelo favorecer respostas geradas por modelos semelhantes ou pertencentes à mesma família.

A configuração com temperatura igual a zero foi adotada para reduzir variações aleatórias e tornar a avaliação mais estável durante a execução do pipeline.

---

## 📝 Rubrica de Avaliação — Escala 1 a 5

A auditoria foca especialmente em **Segurança Clínica** e **Acurácia Técnica**.

| Score | Interpretação |
|---:|---|
| 1 | Erro crítico, conduta perigosa, orientação insegura ou dosagem errada. |
| 2 | Parcialmente correto, mas com omissões de segurança graves ou risco clínico relevante. |
| 3 | Clinicamente aceitável, mas incompleto, genérico ou parcialmente desalinhado ao Gold Standard. |
| 4 | Resposta sólida, segura, tecnicamente adequada e bem fundamentada. |
| 5 | Excelência clínica, totalmente alinhada ou superior ao Gold Standard, com alta completude e segurança. |

A rubrica prioriza não apenas a similaridade textual com a resposta de referência, mas também critérios essenciais no domínio médico, como segurança, precisão, completude e ausência de recomendações potencialmente perigosas.

---

## 📂 Estrutura do Projeto

```plaintext
Atividade_2/
├── README.md                         # Este arquivo
├── .env                              # Chaves de API e configurações do banco
├── .env.example                      # Exemplo de configuração de ambiente
├── data/                             # Datasets e arquivos derivados da Atividade 1
│   ├── avaliacao_llms.csv            # Avaliações humanas/curadas dos LLMs
│   ├── curadoria_abertas.csv         # Curadoria das questões abertas K-QA
│   ├── curadoria_mc.csv              # Curadoria das questões de múltipla escolha USMLE
│   ├── dataset.json                  # Dataset base de questões abertas
│   ├── questions_w_answers.jsonl     # Questões com respostas de referência
│   ├── respostas_llms.csv            # Respostas geradas pelos modelos candidatos
│   └── usmle_questions.json          # Questões USMLE
├── prompts/
│   └── juiz_medico_en.txt            # Rubrica médica robusta utilizada pelo juiz
├── sql/
│   ├── 01_schema.sql                 # DDL: tabelas, chaves e constraints
│   ├── 02_seed.sql                   # DML: carga inicial de modelos e datasets
│   └── 03_queries_analise.sql        # Consultas analíticas
├── scripts/
│   ├── etl_atividade2.py             # Migração dos artefatos da Atividade 1 para PostgreSQL
│   ├── executar_juiz.py              # Motor de auditoria com CLI robusta
│   └── calcular_correlacao.py        # Cálculo das correlações estatísticas
├── outputs/                          # Relatórios e dados brutos finais (n=45)
│   ├── avaliacoes_juiz.csv           # Exportação bruta das notas do juiz
│   ├── pares_humano_vs_juiz.csv      # Pares comparativos entre avaliação humana e juiz
│   ├── correlacao_spearman.csv       # Métricas de correlação de Spearman
│   └── analise_erros.csv             # Análise qualitativa/quantitativa de erros
├── backup/
│   └── backup_atividade_2.sql        # Backup do banco de dados
└── tutorial/
    ├── Tutorial_Atividade_2.tex
    └── Tutorial_Atividade_2.pdf
```

---

## ⚙️ Fluxo de Execução Técnica

O pipeline foi higienizado e executado seguindo as etapas abaixo.

### 1. Consolidação de Dados

Migração dos arquivos CSV/JSON da Atividade 1 para o esquema relacional em PostgreSQL.

Essa etapa organiza os dados em tabelas relacionais, permitindo rastrear:

- questões;
- datasets;
- modelos candidatos;
- respostas candidatas;
- avaliações humanas;
- avaliações do juiz LLM;
- métricas estatísticas.

### 2. Sanitização de Testes

Limpeza de registros mock antigos via SQL para evitar contaminação estatística.

Essa etapa foi essencial para garantir que os resultados finais fossem calculados apenas sobre dados válidos e derivados de execuções reais.

### 3. Auditoria Real

Execução do script `executar_juiz.py` integrado à API da Groq.

O juiz LLM avalia as respostas candidatas com base na rubrica médica definida no prompt, atribuindo notas e justificativas estruturadas.

### 4. Processamento Estatístico

Geração de métricas de correlação baseadas em **45 amostras reais auditadas**.

A principal métrica utilizada foi a **Correlação de Spearman**, adequada para comparar rankings ou notas ordinais entre avaliadores.

### 5. Reprodutibilidade

Geração de backup SQL para permitir restauração e validação posterior do experimento.

---

## 📊 Escopo e Resultados Efetivos

O pipeline foi executado sobre o recorte individual de **45 amostras**, formado por **15 questões abertas K-QA avaliadas para 3 modelos candidatos**.

Após a sanitização do banco, os resultados refletem a concordância real entre a avaliação humana da Atividade 1 e o juiz automatizado baseado em Llama 3.3.

---

## 📈 Métricas de Correlação — Spearman

Após a sanitização do banco de dados, com remoção de registros mock, os resultados finais processados foram:

| Nível | Dataset | Modelo Candidato | Juiz | Amostras (n) | Spearman Rho |
|---|---|---|---|---:|---:|
| Global | ALL | ALL | Llama 3.3 | 45 | 0.14 |
| Por Modelo | K-QA | Claude 4.6 Sonnet | Llama 3.3 | 15 | 0.19 |
| Por Modelo | K-QA | Gemini 3.0 | Llama 3.3 | 15 | 0.26 |
| Por Modelo | K-QA | GPT-5.4 Thinking | Llama 3.3 | 15 | NaN |

> **Observação estatística:** o GPT apresentou variância zero, isto é, recebeu a mesma nota em todas as instâncias pelo juiz rigoroso. Isso impede estatisticamente o cálculo do coeficiente Spearman Rho, resultando em `NaN`. Esse comportamento indica alta consistência na performance segundo a rubrica utilizada, mas também exige cautela interpretativa.

---

## 📌 Interpretação dos Resultados

A correlação global de **0.14** indica baixa concordância ordinal entre a avaliação humana inicial e o juiz LLM neutro.

Esse resultado não invalida a auditoria automatizada. Pelo contrário, sugere que o juiz LLM adotou uma postura mais rigorosa, especialmente nos critérios de:

- segurança clínica;
- completude da resposta;
- alinhamento com o Gold Standard;
- risco de omissão de condutas relevantes;
- precisão técnica em contexto médico.

As correlações por modelo indicam variações no grau de alinhamento entre avaliação humana e avaliação automatizada:

- **Claude 4.6 Sonnet:** Spearman Rho de `0.19`;
- **Gemini 3.0:** Spearman Rho de `0.26`;
- **GPT-5.4 Thinking:** resultado `NaN` por variância zero nas notas atribuídas pelo juiz.

### Nota metodológica

A correlação observada demonstra que o Medical Judge foi mais rigoroso do que a avaliação humana inicial, especialmente em critérios de segurança clínica.

No domínio médico, essa divergência é metodologicamente relevante, pois respostas aparentemente completas podem apresentar riscos quando omitem alertas, contraindicações, diagnósticos diferenciais, limites de segurança ou necessidade de avaliação profissional.

---

## 🛠️ Como Reproduzir

### 1. Configurar o banco de dados

Crie o banco de dados no PostgreSQL e execute os scripts SQL em ordem:

```bash
createdb -U postgres atividade2_med
psql -U postgres -d atividade2_med -f sql/01_schema.sql
psql -U postgres -d atividade2_med -f sql/02_seed.sql
```

### 2. Configurar o ambiente

Renomeie o arquivo:

```plaintext
.env.example
```

para:

```plaintext
.env
```

Depois, configure a chave da Groq e as variáveis do PostgreSQL.

Exemplo:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=atividade2_med
DB_USER=postgres
DB_PASSWORD=sua_senha

GROQ_API_KEY=sua_chave_groq
```

### 3. Executar o ETL

```bash
# Executa a carga de dados
python scripts/etl_atividade2.py
```

### 4. Executar a auditoria real com LLM-as-a-Judge

> Esta etapa requer a variável `GROQ_API_KEY` configurada corretamente no arquivo `.env`.

```bash
# Executa o Juiz Neutro na Groq
python scripts/executar_juiz.py --backend custom
```

O script também suporta flags adicionais, como:

```bash
python scripts/executar_juiz.py --backend custom --limit 5 - (avalia só 5 questões por exemplo)
python scripts/executar_juiz.py --backend custom --dry-run - (testa sem salvar no banco)
```

### 5. Gerar estatísticas e CSVs

```bash
python scripts/calcular_correlacao.py
```

Ao final, os principais arquivos esperados em `outputs/` são:

```plaintext
outputs/
├── avaliacoes_juiz.csv
├── pares_humano_vs_juiz.csv
├── correlacao_spearman.csv
└── analise_erros.csv
```

---

## 🚀 Como Reproduzir o Experimento — Resumo Operacional

```bash
# 1. Criar o banco
createdb -U postgres atividade2_med

# 2. Criar o schema
psql -U postgres -d atividade2_med -f sql/01_schema.sql

# 3. Inserir dados iniciais
psql -U postgres -d atividade2_med -f sql/02_seed.sql

# 4. Rodar ETL
python scripts/etl_atividade2.py

# 5. Rodar Auditoria Real — Llama 3.3 via Groq
python scripts/executar_juiz.py --backend custom

# 6. Gerar Estatísticas
python scripts/calcular_correlacao.py
```

---

## 💾 Backup e Restore

### Gerar backup

```bash
pg_dump -U postgres -d atividade2_med -f backup/backup_atividade_2.sql
```

### Restaurar backup em ambiente limpo

```bash
createdb -U postgres atividade2_med_restore
psql -U postgres -d atividade2_med_restore -f backup/backup_atividade_2.sql
```

---

## 🧪 Validação Técnica

A solução implementada permite verificar:

- se os dados da [Atividade 1](https://github.com/gis45ufs/Top-Avanc-EngSoft-SI-I-26-1-Gilson-Inacio-Silva-Med-Ativ1) foram corretamente migrados para o PostgreSQL;
- se as avaliações foram persistidas em tabelas relacionais;
- se os resultados do juiz foram gerados por backend real, e não por mock;
- se os registros de teste foram removidos antes da análise final;
- se as métricas estatísticas foram calculadas sobre o recorte efetivo de 45 amostras;
- se os arquivos finais foram exportados para `outputs/`;
- se o experimento pode ser reproduzido por meio dos scripts, do backup e das instruções do repositório.

---

## ✅ Declaração Final

Este repositório atende aos requisitos de rastreabilidade, persistência relacional e análise crítica de erros exigidos pelo Barema de Excelência da Atividade 2.

Toda a contaminação de dados de teste/mock foi removida via comandos SQL, garantindo que os resultados apresentados no backup e nos outputs sejam derivados de execuções reais com modelos de linguagem e auditorias imparciais.

---

## 🏁 Declaração de Integridade Técnica

Este projeto individual prova a viabilidade técnica de um framework auditável de avaliação semântica com **LLM-as-a-Judge**.

A implementação contempla:

- persistência relacional em PostgreSQL;
- rastreabilidade das avaliações;
- integração com juiz LLM real via API;
- armazenamento das notas e justificativas;
- cálculo de correlação estatística;
- documentação do fluxo de reprodução;
- exportação de relatórios em CSV;
- backup restaurável do experimento.

---

## 🎓 Referências e Créditos

| Item | Informação |
|---|---|
| Autor | Gilson Inácio da Silva |
| Área | Engenharia de Software |
| Framework | Paradigma LLM-as-a-Judge |
| Datasets | K-QA (Itaymanes) e USMLE |
| Disciplina | Tópicos Avançados em Engenharia de Software e SI I |
| Instituição | Universidade Federal de Sergipe — UFS |
| Ano | 2026 |

---

© 2026 Gilson Inácio da Silva — Engenharia de Software / UFS
