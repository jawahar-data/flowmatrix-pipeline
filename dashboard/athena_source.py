"""Athena-backed data source (gold layer of the AWS data lake)."""
import re
import time
from datetime import date
from typing import Optional

import boto3
import pandas as pd
import streamlit as st

REGION = "ap-southeast-2"
OUTPUT = "s3://flowmatrix-lake-418059030267/athena-results/"
DB = "flowmatrix_gold"


def enabled() -> bool:
    """True when AWS credentials exist in Streamlit secrets."""
    try:
        return "aws" in st.secrets
    except Exception:
        return False


@st.cache_data(ttl=6 * 3600, show_spinner=False)
def query(sql: str) -> pd.DataFrame:
    s = st.secrets["aws"]
    athena = boto3.client(
        "athena",
        region_name=REGION,
        aws_access_key_id=s["access_key_id"],
        aws_secret_access_key=s["secret_access_key"],
    )
    qid = athena.start_query_execution(
        QueryString=sql, ResultConfiguration={"OutputLocation": OUTPUT}
    )["QueryExecutionId"]
    while True:
        status = athena.get_query_execution(QueryExecutionId=qid)["QueryExecution"]["Status"]
        if status["State"] in ("SUCCEEDED", "FAILED", "CANCELLED"):
            break
        time.sleep(0.5)
    if status["State"] != "SUCCEEDED":
        raise RuntimeError(status.get("StateChangeReason", "Athena query failed"))
    rows = []
    for page in athena.get_paginator("get_query_results").paginate(QueryExecutionId=qid):
        for r in page["ResultSet"]["Rows"]:
            rows.append([c.get("VarCharValue") for c in r["Data"]])
    df = pd.DataFrame(rows[1:], columns=rows[0])
    for col in df.columns:
        try:
            df[col] = pd.to_numeric(df[col])
        except (ValueError, TypeError):
            pass
    return df


def _d(d: date) -> str:
    return f"DATE '{d.isoformat()}'"


def _state_clause(col: str, code: Optional[str]) -> str:
    if not code:
        return ""
    if not re.fullmatch(r"[A-Z]{2}", code):
        raise ValueError("invalid state code")
    return f"AND {col} = '{code}'"


def _num(x) -> float:
    return 0 if pd.isna(x) else x


def daily_gmv(start: date, end: date) -> pd.DataFrame:
    df = query(f"""
        SELECT order_date, orders AS total_orders, revenue AS total_gmv,
               avg_order_value AS avg_payment_value, avg_delivery_days
        FROM {DB}.daily_sales
        WHERE order_date BETWEEN {_d(start)} AND {_d(end)}
        ORDER BY order_date""")
    df["order_date"] = pd.to_datetime(df["order_date"])
    return df


def top_sellers(top_n: int = 10, state: Optional[str] = None) -> pd.DataFrame:
    return query(f"""
        SELECT seller_id, MAX(city) AS city, MAX(state) AS state,
               SUM(orders) AS total_orders, SUM(revenue) AS total_revenue
        FROM {DB}.seller_daily
        WHERE 1 = 1 {_state_clause('state', state)}
        GROUP BY seller_id
        ORDER BY total_revenue DESC
        LIMIT {int(top_n)}""")


def order_status(start: date, end: date) -> pd.DataFrame:
    return query(f"""
        SELECT order_status, SUM(order_count) AS order_count
        FROM {DB}.order_status_daily
        WHERE order_date BETWEEN {_d(start)} AND {_d(end)}
        GROUP BY order_status
        ORDER BY order_count DESC""")


def delivery_by_state(state: Optional[str] = None) -> pd.DataFrame:
    return query(f"""
        SELECT customer_state, avg_delivery_days, total_orders
        FROM {DB}.delivery_by_state
        WHERE 1 = 1 {_state_clause('customer_state', state)}
        ORDER BY avg_delivery_days DESC""")


def kpis(start: date, end: date) -> dict:
    r = query(f"""
        SELECT d.total_orders, d.total_gmv, d.avg_delivery_days, s.active_sellers
        FROM (
            SELECT SUM(orders) AS total_orders,
                   SUM(revenue) AS total_gmv,
                   SUM(CASE WHEN avg_delivery_days IS NOT NULL
                            THEN avg_delivery_days * orders END)
                   / NULLIF(SUM(CASE WHEN avg_delivery_days IS NOT NULL
                                     THEN orders END), 0) AS avg_delivery_days
            FROM {DB}.daily_sales
            WHERE order_date BETWEEN {_d(start)} AND {_d(end)}
        ) d
        CROSS JOIN (
            SELECT COUNT(DISTINCT seller_id) AS active_sellers
            FROM {DB}.seller_daily
            WHERE order_date BETWEEN {_d(start)} AND {_d(end)}
        ) s""").iloc[0]
    return {
        "total_orders": int(_num(r["total_orders"])),
        "total_gmv": float(_num(r["total_gmv"])),
        "avg_delivery_days": float(_num(r["avg_delivery_days"])),
        "active_sellers": int(_num(r["active_sellers"])),
    }