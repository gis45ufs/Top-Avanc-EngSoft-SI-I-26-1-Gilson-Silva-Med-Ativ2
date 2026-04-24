#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
calcular_correlacao.py

Calcula a correlação entre:
- nota humana (convertida para 1 a 5)
- nota do Juiz-IA (1 a 5)

Saídas em outputs/:
- pares_humano_vs_juiz.csv
- correlacao_spearman.csv
- analise_erros.csv
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Dict, List

import pandas as pd
import psycopg2
from scipy.stats import spearmanr

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "outputs"

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "atividade2_med"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
}


def connect_db():
    return psycopg2.connect(**DB_CONFIG)


def ensure_output_dir():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def query_pairs() -> str:
    return """
    SELECT
        p.official_id,
        d.nome_dataset,
        m_cand.nome_modelo AS modelo_candidato,
        m_juiz.nome_modelo AS modelo_juiz,
        COALESCE(
            ah.nota_humana_1a5,
            CASE
                WHEN ah.total_score_0_10 >= 9 THEN 5
                WHEN ah.total_score_0_10 >= 7 THEN 4
                WHEN ah.total_score_0_10 >= 5 THEN 3
                WHEN ah.total_score_0_10 >= 3 THEN 2
                ELSE 1
            END
        ) AS nota_humana_1a5,
        a.nota_atribuida AS nota_juiz,
        ah.total_score_0_10,
        ah.clinical_correctness_0_2,
        ah.completeness_0_2,
        ah.alignment_with_gold_0_2,
        ah.safety_0_2,
        ah.clarity_0_2,
        r.texto_resposta,
        a.chain_of_thought
    FROM avaliacoes_juiz a
    JOIN respostas_atividade_1 r
        ON a.id_resposta_ativa1 = r.id_resposta
    JOIN perguntas p
        ON r.id_pergunta = p.id_pergunta
    JOIN datasets d
        ON p.id_dataset = d.id_dataset
    JOIN modelos m_cand
        ON r.id_modelo = m_cand.id_modelo
    JOIN modelos m_juiz
        ON a.id_modelo_juiz = m_juiz.id_modelo
    JOIN avaliacoes_humanas_atividade_1 ah
        ON ah.id_resposta_ativa1 = r.id_resposta
    WHERE ah.total_score_0_10 IS NOT NULL
    ORDER BY d.nome_dataset, p.official_id, m_cand.nome_modelo, m_juiz.nome_modelo
    """


def compute_spearman_safe(df: pd.DataFrame, x_col: str, y_col: str):
    clean = df[[x_col, y_col]].dropna()
    if len(clean) < 2:
        return None, None, len(clean)

    if clean[x_col].nunique() < 2 or clean[y_col].nunique() < 2:
        return None, None, len(clean)

    corr, p_value = spearmanr(clean[x_col], clean[y_col])
    return float(corr), float(p_value), len(clean)


def build_global_results(df: pd.DataFrame) -> List[Dict]:
    results = []

    corr, p_value, n = compute_spearman_safe(df, "nota_humana_1a5", "nota_juiz")
    results.append({
        "nivel": "global",
        "nome_dataset": "ALL",
        "modelo_candidato": "ALL",
        "modelo_juiz": "ALL",
        "n": n,
        "spearman_rho": corr,
        "p_value": p_value,
    })

    for dataset_name, g_dataset in df.groupby("nome_dataset"):
        corr, p_value, n = compute_spearman_safe(g_dataset, "nota_humana_1a5", "nota_juiz")
        results.append({
            "nivel": "por_dataset",
            "nome_dataset": dataset_name,
            "modelo_candidato": "ALL",
            "modelo_juiz": "ALL",
            "n": n,
            "spearman_rho": corr,
            "p_value": p_value,
        })

    for (cand, judge), group in df.groupby(["modelo_candidato", "modelo_juiz"]):
        corr, p_value, n = compute_spearman_safe(group, "nota_humana_1a5", "nota_juiz")
        results.append({
            "nivel": "por_modelo",
            "nome_dataset": "ALL",
            "modelo_candidato": cand,
            "modelo_juiz": judge,
            "n": n,
            "spearman_rho": corr,
            "p_value": p_value,
        })

    for (dataset_name, cand, judge), group in df.groupby(["nome_dataset", "modelo_candidato", "modelo_juiz"]):
        corr, p_value, n = compute_spearman_safe(group, "nota_humana_1a5", "nota_juiz")
        results.append({
            "nivel": "por_dataset_modelo",
            "nome_dataset": dataset_name,
            "modelo_candidato": cand,
            "modelo_juiz": judge,
            "n": n,
            "spearman_rho": corr,
            "p_value": p_value,
        })

    return results


def build_error_analysis(df: pd.DataFrame) -> pd.DataFrame:
    data = df.copy()
    data["diferenca_abs"] = (data["nota_humana_1a5"] - data["nota_juiz"]).abs()

    cond_high_judge_low_human = (data["nota_humana_1a5"] <= 2) & (data["nota_juiz"] >= 4)
    cond_low_judge_high_human = (data["nota_humana_1a5"] >= 4) & (data["nota_juiz"] <= 2)
    cond_large_gap = data["diferenca_abs"] >= 2

    error_df = data[
        cond_high_judge_low_human |
        cond_low_judge_high_human |
        cond_large_gap
    ].copy()

    error_df["tipo_erro"] = "divergencia_relevante"
    error_df.loc[cond_high_judge_low_human, "tipo_erro"] = "juiz_superestimou_resposta_fraca"
    error_df.loc[cond_low_judge_high_human, "tipo_erro"] = "juiz_subestimou_resposta_boa"

    cols = [
        "official_id",
        "nome_dataset",
        "modelo_candidato",
        "modelo_juiz",
        "nota_humana_1a5",
        "nota_juiz",
        "total_score_0_10",
        "clinical_correctness_0_2",
        "completeness_0_2",
        "alignment_with_gold_0_2",
        "safety_0_2",
        "clarity_0_2",
        "diferenca_abs",
        "tipo_erro",
        "texto_resposta",
        "chain_of_thought",
    ]
    return error_df[cols].sort_values(
        by=["diferenca_abs", "official_id", "modelo_candidato"],
        ascending=[False, True, True]
    )


def save_outputs(df_pairs: pd.DataFrame, df_corr: pd.DataFrame, df_errors: pd.DataFrame) -> None:
    ensure_output_dir()
    df_pairs.to_csv(OUTPUT_DIR / "pares_humano_vs_juiz.csv", index=False, encoding="utf-8-sig")
    df_corr.to_csv(OUTPUT_DIR / "correlacao_spearman.csv", index=False, encoding="utf-8-sig")
    df_errors.to_csv(OUTPUT_DIR / "analise_erros.csv", index=False, encoding="utf-8-sig")


def print_summary(df_corr: pd.DataFrame):
    print("\n=== RESUMO DA CORRELAÇÃO ===")
    for _, row in df_corr.iterrows():
        print(
            f"[{row['nivel']}] "
            f"dataset={row['nome_dataset']} | "
            f"cand={row['modelo_candidato']} | "
            f"juiz={row['modelo_juiz']} | "
            f"n={row['n']} | "
            f"rho={row['spearman_rho']} | "
            f"p={row['p_value']}"
        )


def main():
    conn = connect_db()
    try:
        df_pairs = pd.read_sql(query_pairs(), conn)
        if df_pairs.empty:
            print("Nenhum par humano vs juiz encontrado no banco.")
            return

        corr_results = build_global_results(df_pairs)
        df_corr = pd.DataFrame(corr_results)
        df_errors = build_error_analysis(df_pairs)

        save_outputs(df_pairs, df_corr, df_errors)
        print_summary(df_corr)

        print("\nArquivos gerados:")
        print(f"- {OUTPUT_DIR / 'pares_humano_vs_juiz.csv'}")
        print(f"- {OUTPUT_DIR / 'correlacao_spearman.csv'}")
        print(f"- {OUTPUT_DIR / 'analise_erros.csv'}")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
