#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
executar_juiz.py

Executa o pipeline LLM-as-a-Judge da Atividade 2 no domínio médico.

O script:
1. Conecta ao PostgreSQL
2. Busca respostas candidatas da Atividade 1 ainda não julgadas pelo modelo juiz
3. Monta o prompt do juiz usando:
   - pergunta
   - resposta ouro
   - resposta candidata
4. Chama o backend configurado
5. Faz parsing de:
   REASONING: ...
   SCORE: <1 a 5>
6. Salva em avaliacoes_juiz

Observação importante:
- Este script está pronto no pipeline.
- A chamada do modelo juiz pode rodar em modo MOCK para teste local.
- Para produção, a equipe deve implementar o backend real do provedor escolhido.
"""

from __future__ import annotations

import argparse
import os
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import psycopg2
from psycopg2.extras import RealDictCursor

ROOT = Path(__file__).resolve().parents[1]
PROMPT_PATH = ROOT / "prompts" / "juiz_medico_en.txt"
OUTPUT_DIR = ROOT / "outputs"

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "atividade2_med"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
}

DEFAULT_JUDGE_MODEL_NAME = os.getenv("JUDGE_MODEL_NAME", "JUDGE_MODEL")
DEFAULT_BACKEND = os.getenv("JUDGE_BACKEND", "mock")  # mock | custom


def connect_db():
    return psycopg2.connect(**DB_CONFIG)


def ensure_output_dir():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def load_prompt_template() -> str:
    if not PROMPT_PATH.exists():
        raise FileNotFoundError(f"Prompt não encontrado em: {PROMPT_PATH}")
    return PROMPT_PATH.read_text(encoding="utf-8")


def build_prompt(template: str, question: str, gold_answer: str, candidate_answer: str) -> str:
    return (
        template
        .replace("{question}", question.strip())
        .replace("{gold_answer}", gold_answer.strip())
        .replace("{candidate_answer}", candidate_answer.strip())
    )


def parse_judge_output(raw_text: str) -> Tuple[str, int]:
    text = raw_text.strip()
    if not text:
        raise ValueError("Saída vazia do juiz.")

    reasoning_match = re.search(
        r"REASONING:\s*(.*?)(?:\n\s*SCORE:|\Z)",
        text,
        flags=re.IGNORECASE | re.DOTALL
    )
    score_match = re.search(
        r"SCORE:\s*([1-5])\b",
        text,
        flags=re.IGNORECASE
    )

    if not score_match:
        raise ValueError(f"Não foi possível extrair SCORE da saída:\n{text}")

    score = int(score_match.group(1))
    reasoning = reasoning_match.group(1).strip() if reasoning_match else "No reasoning extracted."
    if not reasoning:
        reasoning = "No reasoning extracted."

    return reasoning, score


def get_or_create_judge_model_id(conn, judge_model_name: str) -> int:
    with conn.cursor() as cur:
        cur.execute(
            "SELECT id_modelo FROM modelos WHERE nome_modelo = %s",
            (judge_model_name,)
        )
        row = cur.fetchone()
        if row:
            return row[0]

        cur.execute(
            """
            INSERT INTO modelos (nome_modelo, versao, papel, parametro_precisao, observacoes)
            VALUES (%s, %s, 'juiz', %s, %s)
            RETURNING id_modelo
            """,
            (judge_model_name, None, "N/A", "Modelo juiz criado automaticamente pelo script")
        )
        return cur.fetchone()[0]


def fetch_pending_responses(conn, judge_model_id: int, limit: Optional[int] = None) -> List[Dict]:
    query = """
        SELECT
            r.id_resposta,
            p.official_id,
            d.nome_dataset,
            p.enunciado AS question,
            p.resposta_ouro AS gold_answer,
            r.texto_resposta AS candidate_answer,
            m.nome_modelo AS candidate_model_name
        FROM respostas_atividade_1 r
        JOIN perguntas p ON r.id_pergunta = p.id_pergunta
        JOIN datasets d ON p.id_dataset = d.id_dataset
        JOIN modelos m ON r.id_modelo = m.id_modelo
        LEFT JOIN avaliacoes_juiz a
            ON a.id_resposta_ativa1 = r.id_resposta
           AND a.id_modelo_juiz = %s
        WHERE a.id_avaliacao IS NULL
        ORDER BY d.nome_dataset, p.official_id, m.nome_modelo
    """

    params = [judge_model_id]

    if limit is not None:
        query += " LIMIT %s"
        params.append(limit)

    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(query, params)
        rows = cur.fetchall()

    return [dict(r) for r in rows]


def save_judge_evaluation(conn, id_resposta: int, judge_model_id: int, reasoning: str, score: int) -> None:
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO avaliacoes_juiz (
                id_resposta_ativa1,
                id_modelo_juiz,
                nota_atribuida,
                chain_of_thought
            )
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (id_resposta_ativa1, id_modelo_juiz)
            DO UPDATE SET
                nota_atribuida = EXCLUDED.nota_atribuida,
                chain_of_thought = EXCLUDED.chain_of_thought,
                data_avaliacao = CURRENT_TIMESTAMP
            """,
            (id_resposta, judge_model_id, score, reasoning)
        )


def call_judge_backend_mock(prompt: str, payload: Dict) -> str:
    candidate_answer = payload["candidate_answer"].lower()
    gold_answer = payload["gold_answer"].lower()

    overlap = 0
    for token in ["not", "contraind", "danger", "dose", "mg", "safe", "monitor", "follow-up"]:
        if token in candidate_answer:
            overlap += 1

    if len(candidate_answer.strip()) < 20:
        score = 2
        reasoning = "The answer is too short and likely incomplete for safe clinical evaluation."
    elif candidate_answer in gold_answer or gold_answer[:80] in candidate_answer:
        score = 5
        reasoning = "The answer is highly aligned with the gold standard and appears clinically safe."
    elif overlap >= 2:
        score = 4
        reasoning = "The answer appears clinically reasonable and includes some relevant safety-oriented content."
    else:
        score = 3
        reasoning = "The answer is broadly acceptable but may be incomplete or less aligned with the gold standard."

    return f"REASONING: {reasoning}\nSCORE: {score}"


def call_judge_backend_custom(prompt: str, payload: Dict) -> str:
    raise NotImplementedError(
        "Implemente call_judge_backend_custom() com o provedor escolhido pela equipe."
    )


def call_judge_model(prompt: str, payload: Dict, backend: str) -> str:
    backend = backend.lower().strip()
    if backend == "mock":
        return call_judge_backend_mock(prompt, payload)
    if backend == "custom":
        return call_judge_backend_custom(prompt, payload)
    raise ValueError(f"Backend inválido: {backend}")


def run(limit: Optional[int], backend: str, judge_model_name: str, dry_run: bool) -> None:
    ensure_output_dir()
    prompt_template = load_prompt_template()

    conn = connect_db()
    conn.autocommit = False

    try:
        judge_model_id = get_or_create_judge_model_id(conn, judge_model_name)
        conn.commit()

        pending = fetch_pending_responses(conn, judge_model_id=judge_model_id, limit=limit)
        if not pending:
            print("Nenhuma resposta pendente para julgamento.")
            return

        print(f"Total pendente: {len(pending)}")
        success = 0
        failures = 0

        for idx, item in enumerate(pending, start=1):
            prompt = build_prompt(
                template=prompt_template,
                question=item["question"],
                gold_answer=item["gold_answer"],
                candidate_answer=item["candidate_answer"]
            )

            payload = {
                "question": item["question"],
                "gold_answer": item["gold_answer"],
                "candidate_answer": item["candidate_answer"],
                "candidate_model_name": item["candidate_model_name"],
                "official_id": item["official_id"],
                "dataset_name": item["nome_dataset"],
            }

            try:
                raw_output = call_judge_model(prompt=prompt, payload=payload, backend=backend)
                reasoning, score = parse_judge_output(raw_output)

                if dry_run:
                    print(f"[DRY-RUN] Q{item['official_id']} | {item['candidate_model_name']} | score={score}")
                else:
                    save_judge_evaluation(
                        conn=conn,
                        id_resposta=item["id_resposta"],
                        judge_model_id=judge_model_id,
                        reasoning=reasoning,
                        score=score
                    )
                    conn.commit()

                success += 1
                print(f"[OK {idx}/{len(pending)}] Q{item['official_id']} | {item['candidate_model_name']} | score={score}")

            except Exception as e:
                conn.rollback()
                failures += 1
                print(f"[ERRO {idx}/{len(pending)}] Q{item['official_id']} | {item['candidate_model_name']} | {e}")

        print(f"\nFinalizado. Sucessos: {success} | Falhas: {failures}")

    finally:
        conn.close()


def main():
    parser = argparse.ArgumentParser(description="Executa o Juiz-IA da Atividade 2.")
    parser.add_argument("--limit", type=int, default=None, help="Limita a quantidade de respostas julgadas.")
    parser.add_argument("--backend", type=str, default=DEFAULT_BACKEND, help="Backend do juiz: mock | custom")
    parser.add_argument("--judge-model-name", type=str, default=DEFAULT_JUDGE_MODEL_NAME, help="Nome do modelo juiz no banco.")
    parser.add_argument("--dry-run", action="store_true", help="Executa sem gravar no banco.")
    args = parser.parse_args()

    run(
        limit=args.limit,
        backend=args.backend,
        judge_model_name=args.judge_model_name,
        dry_run=args.dry_run,
    )


if __name__ == "__main__":
    main()
