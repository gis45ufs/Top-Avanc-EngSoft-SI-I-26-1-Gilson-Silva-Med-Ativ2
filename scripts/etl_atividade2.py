#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import annotations

import csv
import os
from pathlib import Path
from typing import Dict, List, Optional

import psycopg2
from psycopg2.extras import Json

ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data"

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "atividade2_med"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
}


def connect_db():
    return psycopg2.connect(**DB_CONFIG)


def load_csv(path: Path) -> List[Dict[str, str]]:
    """
    Lê CSV tentando múltiplas codificações e detectando automaticamente
    o delimitador mais provável.
    """
    if not path.exists():
        raise FileNotFoundError(f"Arquivo não encontrado: {path}")

    encodings_to_try = ["utf-8-sig", "utf-8", "cp1252", "latin-1"]
    last_error = None

    for enc in encodings_to_try:
        try:
            with open(path, "r", encoding=enc, newline="") as f:
                sample = f.read(4096)
                f.seek(0)

                try:
                    dialect = csv.Sniffer().sniff(sample, delimiters=";,|\t")
                    delimiter = dialect.delimiter
                except csv.Error:
                    delimiter = ";"

                reader = csv.DictReader(f, delimiter=delimiter)

                if reader.fieldnames:
                    reader.fieldnames = [
                        fn.strip() if isinstance(fn, str) else fn
                        for fn in reader.fieldnames
                    ]

                rows: List[Dict[str, str]] = []
                for row in reader:
                    cleaned_row = {
                        (k.strip() if isinstance(k, str) else k):
                        (v.strip() if isinstance(v, str) else v)
                        for k, v in row.items()
                    }
                    rows.append(cleaned_row)

            print(f"[OK] CSV lido com encoding '{enc}' e delimitador '{delimiter}': {path.name}")
            print(f"     Colunas detectadas: {reader.fieldnames}")
            return rows

        except UnicodeDecodeError as e:
            last_error = e

    raise RuntimeError(
        f"Não foi possível ler o arquivo CSV '{path.name}' com os encodings tentados "
        f"({', '.join(encodings_to_try)}). Erro final: {last_error}"
    )


def validate_required_columns(rows: List[Dict[str, str]], required_columns: List[str], file_label: str) -> None:
    if not rows:
        raise ValueError(f"O arquivo {file_label} não possui linhas de dados.")

    available = list(rows[0].keys())
    missing = [col for col in required_columns if col not in available]

    if missing:
        raise ValueError(
            f"O arquivo {file_label} não foi interpretado corretamente.\n"
            f"Colunas ausentes: {missing}\n"
            f"Colunas detectadas: {available}"
        )


def nota_0_10_para_1_5(total_score: Optional[str]) -> Optional[int]:
    if total_score is None or str(total_score).strip() == "":
        return None
    score = int(float(total_score))
    if score >= 9:
        return 5
    if score >= 7:
        return 4
    if score >= 5:
        return 3
    if score >= 3:
        return 2
    return 1


def safe_int_float(value: Optional[str], default: int = 0) -> int:
    """Converte com segurança valores numéricos vindos do CSV (evita erro de célula vazia)."""
    if not value or str(value).strip() == "":
        return default
    try:
        return int(float(value))
    except ValueError:
        return default


def get_dataset_id(cur, nome_dataset: str) -> int:
    cur.execute("SELECT id_dataset FROM datasets WHERE nome_dataset = %s", (nome_dataset,))
    row = cur.fetchone()
    if not row:
        raise ValueError(f"Dataset não encontrado: {nome_dataset}")
    return row[0]


def get_model_id(cur, nome_modelo: str) -> int:
    cur.execute("SELECT id_modelo FROM modelos WHERE nome_modelo = %s", (nome_modelo,))
    row = cur.fetchone()
    if not row:
        raise ValueError(f"Modelo não encontrado: {nome_modelo}")
    return row[0]


def insert_open_questions(cur, rows_curadoria_abertas: List[Dict[str, str]]) -> None:
    id_dataset = get_dataset_id(cur, "K-QA")
    for row in rows_curadoria_abertas:
        if not row.get("official_id"):
            continue
        official_id = int(row["official_id"])
        enunciado = (row.get("question") or "").strip()
        resposta_ouro = (row.get("gold_answer") or "").strip()
        if not enunciado:
            raise ValueError(f"Pergunta aberta sem enunciado no official_id={official_id}")
        metadados = {
            "student": row.get("student"),
            "team": row.get("team"),
            "must_have": row.get("must_have"),
            "nice_to_have": row.get("nice_to_have"),
            "sources": row.get("sources"),
            "model_1_name": row.get("model_1_name"),
            "model_2_name": row.get("model_2_name"),
            "model_3_name": row.get("model_3_name"),
            "observations": row.get("observations"),
            "difficulty": row.get("difficulty"),
            "specialty": row.get("specialty"),
            "reference_used": row.get("reference_used"),
            "curator_notes": row.get("curator_notes"),
        }
        cur.execute(
            '''
            INSERT INTO perguntas (id_dataset, official_id, enunciado, resposta_ouro, metadados)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (id_dataset, official_id)
            DO UPDATE SET
                enunciado = EXCLUDED.enunciado,
                resposta_ouro = EXCLUDED.resposta_ouro,
                metadados = EXCLUDED.metadados
            ''',
            (id_dataset, official_id, enunciado, resposta_ouro, Json(metadados))
        )


def insert_mc_questions_and_options(cur, rows_curadoria_mc: List[Dict[str, str]]) -> None:
    id_dataset = get_dataset_id(cur, "USMLE")
    option_letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
    for row in rows_curadoria_mc:
        if not row.get("official_id"):
            continue
        official_id = int(row["official_id"])
        enunciado = (row.get("question") or "").strip()
        resposta_ouro = ((row.get("correct_answer_usmle") or "").strip() or (row.get("correct_answer_dataset") or "").strip())
        if not enunciado:
            raise ValueError(f"Questão MC sem enunciado no official_id={official_id}")
        metadados = {
            "student": row.get("student"),
            "team": row.get("team"),
            "dataset_source_index": row.get("dataset_source_index"),
            "usmle_source_index": row.get("usmle_source_index"),
            "difficulty": row.get("difficulty"),
            "specialty": row.get("specialty"),
            "reference_used": row.get("reference_used"),
            "explanation": row.get("explanation"),
            "curator_notes": row.get("curator_notes"),
        }
        cur.execute(
            '''
            INSERT INTO perguntas (id_dataset, official_id, enunciado, resposta_ouro, metadados)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (id_dataset, official_id)
            DO UPDATE SET
                enunciado = EXCLUDED.enunciado,
                resposta_ouro = EXCLUDED.resposta_ouro,
                metadados = EXCLUDED.metadados
            ''',
            (id_dataset, official_id, enunciado, resposta_ouro, Json(metadados))
        )
        cur.execute("SELECT id_pergunta FROM perguntas WHERE id_dataset = %s AND official_id = %s", (id_dataset, official_id))
        result = cur.fetchone()
        if not result:
            raise ValueError(f"Pergunta MC não encontrada após insert: official_id={official_id}")
        id_pergunta = result[0]
        for letra in option_letters:
            key = f"option_{letra}"
            texto = (row.get(key) or "").strip()
            if not texto:
                continue
            is_correta = (letra == resposta_ouro)
            cur.execute(
                '''
                INSERT INTO alternativas (id_pergunta, letra, texto, is_correta)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (id_pergunta, letra)
                DO UPDATE SET
                    texto = EXCLUDED.texto,
                    is_correta = EXCLUDED.is_correta
                ''',
                (id_pergunta, letra, texto, is_correta)
            )


def insert_open_candidate_answers(cur, rows_respostas_llms: List[Dict[str, str]]) -> None:
    id_dataset = get_dataset_id(cur, "K-QA")
    for row in rows_respostas_llms:
        if not row.get("official_id"):
            continue
        official_id = int(row["official_id"])
        cur.execute("SELECT id_pergunta FROM perguntas WHERE id_dataset = %s AND official_id = %s", (id_dataset, official_id))
        result = cur.fetchone()
        if not result:
            raise ValueError(f"Pergunta aberta não encontrada para official_id={official_id}")
        id_pergunta = result[0]
        model_pairs = [
            (row.get("model_1_name"), row.get("model_1_answer")),
            (row.get("model_2_name"), row.get("model_2_answer")),
            (row.get("model_3_name"), row.get("model_3_answer")),
        ]
        for model_name, answer_text in model_pairs:
            model_name = (model_name or "").strip()
            answer_text = (answer_text or "").strip()
            if not model_name or not answer_text:
                continue
            id_modelo = get_model_id(cur, model_name)
            cur.execute(
                '''
                INSERT INTO respostas_atividade_1 (id_pergunta, id_modelo, texto_resposta, origem)
                VALUES (%s, %s, %s, 'atividade_1')
                ON CONFLICT (id_pergunta, id_modelo, origem)
                DO UPDATE SET texto_resposta = EXCLUDED.texto_resposta
                ''',
                (id_pergunta, id_modelo, answer_text)
            )


def insert_human_evaluations(cur, rows_avaliacao: List[Dict[str, str]]) -> None:
    id_dataset = get_dataset_id(cur, "K-QA")
    for row in rows_avaliacao:
        if not row.get("official_id"):
            continue
        official_id = int(row["official_id"])
        model_name = (row.get("model_name") or "").strip()
        if not model_name:
            raise ValueError(f"model_name ausente na avaliação humana do official_id={official_id}")
        cur.execute(
            '''
            SELECT r.id_resposta
            FROM respostas_atividade_1 r
            JOIN perguntas p ON r.id_pergunta = p.id_pergunta
            JOIN modelos m ON r.id_modelo = m.id_modelo
            WHERE p.id_dataset = %s
              AND p.official_id = %s
              AND m.nome_modelo = %s
            ''',
            (id_dataset, official_id, model_name)
        )
        result = cur.fetchone()
        if not result:
            raise ValueError(f"Resposta da Atividade 1 não encontrada para official_id={official_id}, modelo={model_name}")
        id_resposta = result[0]
        total_score = row.get("total_score_0_10")
        nota_humana_1a5 = nota_0_10_para_1_5(total_score)
        
        cur.execute(
            '''
            INSERT INTO avaliacoes_humanas_atividade_1 (
                id_resposta_ativa1,
                clinical_correctness_0_2,
                completeness_0_2,
                alignment_with_gold_0_2,
                safety_0_2,
                clarity_0_2,
                total_score_0_10,
                nota_humana_1a5,
                comentarios
            )
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
            ON CONFLICT (id_resposta_ativa1)
            DO UPDATE SET
                clinical_correctness_0_2 = EXCLUDED.clinical_correctness_0_2,
                completeness_0_2 = EXCLUDED.completeness_0_2,
                alignment_with_gold_0_2 = EXCLUDED.alignment_with_gold_0_2,
                safety_0_2 = EXCLUDED.safety_0_2,
                clarity_0_2 = EXCLUDED.clarity_0_2,
                total_score_0_10 = EXCLUDED.total_score_0_10,
                nota_humana_1a5 = EXCLUDED.nota_humana_1a5,
                comentarios = EXCLUDED.comentarios,
                data_avaliacao = CURRENT_TIMESTAMP
            ''',
            (
                id_resposta,
                safe_int_float(row.get("clinical_correctness_0_2")),
                safe_int_float(row.get("completeness_0_2")),
                safe_int_float(row.get("alignment_with_gold_0_2")),
                safe_int_float(row.get("safety_0_2")),
                safe_int_float(row.get("clarity_0_2")),
                safe_int_float(total_score),
                nota_humana_1a5,
                row.get("comments"),
            )
        )


def print_summary(cur) -> None:
    checks = [
        ("datasets", "SELECT COUNT(*) FROM datasets"),
        ("modelos", "SELECT COUNT(*) FROM modelos"),
        ("perguntas", "SELECT COUNT(*) FROM perguntas"),
        ("alternativas", "SELECT COUNT(*) FROM alternativas"),
        ("respostas_atividade_1", "SELECT COUNT(*) FROM respostas_atividade_1"),
        ("avaliacoes_humanas_atividade_1", "SELECT COUNT(*) FROM avaliacoes_humanas_atividade_1"),
    ]
    print("\n=== RESUMO DO ETL ===")
    for name, sql in checks:
        cur.execute(sql)
        total = cur.fetchone()[0]
        print(f"{name}: {total}")


def main():
    print("Iniciando ETL da Atividade 2...")
    print(f"ROOT = {ROOT}")
    print(f"DATA_DIR = {DATA_DIR}")

    rows_curadoria_abertas = load_csv(DATA_DIR / "curadoria_abertas.csv")
    rows_curadoria_mc = load_csv(DATA_DIR / "curadoria_mc.csv")
    rows_respostas_llms = load_csv(DATA_DIR / "respostas_llms.csv")
    rows_avaliacao = load_csv(DATA_DIR / "avaliacao_llms.csv")
    
    validate_required_columns(
        rows_curadoria_abertas,
        ["official_id", "question", "gold_answer"],
        "curadoria_abertas.csv"
    )

    validate_required_columns(
        rows_curadoria_mc,
        ["official_id", "question"],
        "curadoria_mc.csv"
    )

    validate_required_columns(
        rows_respostas_llms,
        ["official_id", "model_1_name", "model_1_answer"],
        "respostas_llms.csv"
    )

    validate_required_columns(
        rows_avaliacao,
        ["official_id", "model_name", "total_score_0_10"],
        "avaliacao_llms.csv"
    )
    
    print(f"Linhas curadoria_abertas: {len(rows_curadoria_abertas)}")
    print(f"Linhas curadoria_mc: {len(rows_curadoria_mc)}")
    print(f"Linhas respostas_llms: {len(rows_respostas_llms)}")
    print(f"Linhas avaliacao_llms: {len(rows_avaliacao)}")

    conn = connect_db()
    conn.autocommit = False
    cur = conn.cursor()

    try:
        insert_open_questions(cur, rows_curadoria_abertas)
        print("[OK] Perguntas abertas inseridas/atualizadas.")
        insert_mc_questions_and_options(cur, rows_curadoria_mc)
        print("[OK] Questões de múltipla escolha e alternativas inseridas/atualizadas.")
        insert_open_candidate_answers(cur, rows_respostas_llms)
        print("[OK] Respostas candidatas da Atividade 1 inseridas/atualizadas.")
        insert_human_evaluations(cur, rows_avaliacao)
        print("[OK] Avaliações humanas da Atividade 1 inseridas/atualizadas.")
        conn.commit()
        print("\nETL concluído com sucesso.")
        print_summary(cur)
    except Exception as e:
        conn.rollback()
        print(f"\nErro no ETL: {e}")
        raise
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    main()