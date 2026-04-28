#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import annotations
import argparse
import os
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import psycopg2
from psycopg2.extras import RealDictCursor
from openai import OpenAI
from dotenv import load_dotenv

# Carrega variáveis do arquivo .env
load_dotenv()

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

DEFAULT_JUDGE_MODEL_NAME = os.getenv("JUDGE_MODEL_NAME", "llama-3.3-70b-versatile")
DEFAULT_BACKEND = os.getenv("JUDGE_BACKEND", "custom")

def connect_db():
    return psycopg2.connect(**DB_CONFIG)

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
    reasoning_match = re.search(r"REASONING:\s*(.*?)(?:\n\s*SCORE:|\Z)", text, flags=re.IGNORECASE | re.DOTALL)
    score_match = re.search(r"SCORE:\s*([1-5])\b", text, flags=re.IGNORECASE)
    if not score_match:
        raise ValueError(f"Não foi possível extrair SCORE da saída:\n{text}")
    score = int(score_match.group(1))
    reasoning = reasoning_match.group(1).strip() if reasoning_match else "No reasoning extracted."
    return reasoning, score

def get_or_create_judge_model_id(conn, judge_model_name: str) -> int:
    with conn.cursor() as cur:
        cur.execute("SELECT id_modelo FROM modelos WHERE nome_modelo = %s", (judge_model_name,))
        row = cur.fetchone()
        if row: return row[0]
        cur.execute("INSERT INTO modelos (nome_modelo, versao, papel, parametro_precisao, observacoes) VALUES (%s, %s, 'juiz', %s, %s) RETURNING id_modelo", (judge_model_name, None, "N/A", "Modelo juiz Groq"))
        return cur.fetchone()[0]

def fetch_pending_responses(conn, judge_model_id: int, limit: Optional[int] = None) -> List[Dict]:
    query = """
        SELECT r.id_resposta, p.official_id, d.nome_dataset, p.enunciado AS question, p.resposta_ouro AS gold_answer, r.texto_resposta AS candidate_answer, m.nome_modelo AS candidate_model_name
        FROM respostas_atividade_1 r
        JOIN perguntas p ON r.id_pergunta = p.id_pergunta
        JOIN datasets d ON p.id_dataset = d.id_dataset
        JOIN modelos m ON r.id_modelo = m.id_modelo
        LEFT JOIN avaliacoes_juiz a ON a.id_resposta_ativa1 = r.id_resposta AND a.id_modelo_juiz = %s
        WHERE a.id_avaliacao IS NULL
        ORDER BY d.nome_dataset, p.official_id, m.nome_modelo
    """
    params = [judge_model_id]
    if limit: query += f" LIMIT {limit}"
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(query, params)
        return [dict(r) for r in cur.fetchall()]

def call_judge_backend_custom(prompt: str) -> str:
    client = OpenAI(api_key=os.getenv("GROQ_API_KEY"), base_url="https://api.groq.com/openai/v1")
    response = client.chat.completions.create(
        model=os.getenv("JUDGE_MODEL_NAME", "llama-3.3-70b-versatile"),
        messages=[{"role": "system", "content": "You are a senior medical auditor. Format: REASONING: [Step-by-step] SCORE: [1-5]"}, {"role": "user", "content": prompt}],
        temperature=0.0
    )
    return response.choices[0].message.content

def run(limit: Optional[int], backend: str, judge_model_name: str, dry_run: bool) -> None:
    conn = connect_db()
    conn.autocommit = False
    try:
        judge_model_id = get_or_create_judge_model_id(conn, judge_model_name)
        conn.commit()
        pending = fetch_pending_responses(conn, judge_model_id, limit)
        if not pending:
            print("Nenhuma resposta pendente para julgamento.")
            return
            
        print(f"Total pendente: {len(pending)}")
        template = load_prompt_template()
        for idx, item in enumerate(pending, start=1):
            prompt = build_prompt(template, item["question"], item["gold_answer"], item["candidate_answer"])
            
            try:
                raw_output = call_judge_backend_custom(prompt) if backend == "custom" else "REASONING: Mock. SCORE: 3"
                reasoning, score = parse_judge_output(raw_output)
                
                if not dry_run:
                    with conn.cursor() as cur:
                        cur.execute("""
                            INSERT INTO avaliacoes_juiz (id_resposta_ativa1, id_modelo_juiz, nota_atribuida, chain_of_thought)
                            VALUES (%s, %s, %s, %s) ON CONFLICT DO NOTHING""", (item["id_resposta"], judge_model_id, score, reasoning))
                    conn.commit()
                print(f"[OK {idx}/{len(pending)}] Q{item['official_id']} | {item['candidate_model_name']} | Score: {score}")
            except Exception as e:
                conn.rollback()
                print(f"[ERRO {idx}/{len(pending)}] Q{item['official_id']} | {item['candidate_model_name']} | {e}")
                
    finally: conn.close()

if __name__ == "__main__":
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