# ⚡ FlowMatrix
![CI](https://github.com/j26219096-prog/flowmatrix-pipeline/actions/workflows/ci.yml/badge.svg)
![SQL Checks](https://github.com/j26219096-prog/flowmatrix-pipeline/actions/workflows/sql-validation.yml/badge.svg)
### End-to-End E-Commerce ELT Pipeline

FlowMatrix is a personal data engineering project that demonstrates a complete, production-patterned ELT pipeline for e-commerce order analytics. It covers real-time stream ingestion, distributed transformation, analytics engineering, workflow orchestration, automated data quality validation, and a live dashboard.

> **Deployment note:** Kafka, PySpark, and Airflow run **locally via Docker** during development and demo. The Streamlit dashboard and Neon PostgreSQL database are **deployed and publicly accessible** in the cloud. Full cloud orchestration (e.g. AWS Glue/MWAA) is a planned future enhancement.

---

## 🔗 Live Components

| Component | Status | URL |
|-----------|--------|-----|
| Streamlit Dashboard | ✅ Live (Streamlit Cloud) | [flowmarics.streamlit.app](https://flowmarics.streamlit.app) |
| PostgreSQL Database | ✅ Live (Neon Serverless) | Connected to dashboard |
| Kafka / Airflow / PySpark | 🐳 Local (Docker Compose) | Run via `make up` |

---

## 📊 Verified Pipeline Metrics

The following metrics were captured from actual dbt logs, DAG definitions, and schema files during a full pipeline test run. They reflect one historical execution — not the current live database size.

| Metric | Value | Source |
|--------|-------|--------|
| Streaming events processed | 1,247 (500 orders + 747 payments) | Kafka consumer logs |
| dbt models | 7 | `models/` directory |
| Automated data-quality tests | 34 (100% pass rate) | Great Expectations suite |
| Airflow DAG tasks | 6 | DAG definition file |
| End-to-end pipeline runtime | < 2 minutes | Pipeline execution logs |

**Live dashboard (current state):** 834 total orders · R$969,665 GMV — independently verifiable at [flowmarics.streamlit.app](https://flowmarics.streamlit.app).

---

## 🚀 Features

- 📥 **Real-Time Stream Ingestion** — Apache Kafka consumer groups with configurable fault tolerance
- ⚡ **Distributed Transformation** — PySpark jobs for cleaning, deduplication, and schema validation
- 🌊 **Workflow Orchestration** — 6-task Apache Airflow DAG managing pipeline execution order
- 🗄️ **Analytics Engineering** — 7 dbt models structuring analytics-ready tables
- ✅ **Data Quality Validation** — 34 automated Great Expectations tests (100% pass rate)
- 📊 **Live Dashboard** — Streamlit app showing GMV trends, order volume, and data freshness
- 🐳 **Dockerized Local Setup** — Full stack reproducible via Docker Compose + Makefile
- 🔄 **CI/CD** — GitHub Actions pipeline for linting and test checks
- ☁️ **Cloud PostgreSQL** — Neon serverless Postgres as the analytics warehouse

---

## 🏗️ Architecture

```
Simulated Events
      │
      ▼
┌─────────────────┐     Local (Docker)
│  Apache Kafka   │ ──► Consumer Groups · Fault-Tolerant
└────────┬────────┘
         │
         ▼
┌─────────────────┐     Local (Docker)
│  PySpark Jobs   │ ──► Clean · Deduplicate · Enrich · Schema-Validate
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐     Local (Docker)
│  Apache Airflow DAG     │ ──► 6-task orchestration
│  + dbt (7 models)       │ ──► Analytics-ready tables
└────────┬────────────────┘
         │
         ▼
┌─────────────────┐     ☁️ Cloud (Neon)
│  PostgreSQL     │ ──► Serverless · Analytics warehouse
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ☁️ Cloud (Streamlit Cloud)
│  Streamlit      │ ──► GMV · Order trends · Freshness metrics
└─────────────────┘

     ─────────────────────────────────────────
     ✓ Great Expectations — 34 automated data-quality tests
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Stream Ingestion | Apache Kafka |
| Transformation | PySpark |
| Orchestration | Apache Airflow |
| Analytics Engineering | dbt |
| Data Quality | Great Expectations |
| Warehouse | PostgreSQL (Neon Serverless) |
| Dashboard | Streamlit |
| Containerisation | Docker · Docker Compose |
| CI/CD | GitHub Actions |
| Language | Python · SQL |

---

## 🚦 Quick Start (Local)

```bash
# 1. Clone the repo
git clone https://github.com/j26219096-prog/flowmatrix-pipeline.git
cd flowmatrix-pipeline

# 2. Copy and configure environment variables
cp .env.example .env
# Edit .env with your Neon PostgreSQL connection string

# 3. Start all local services (Kafka, Airflow, Spark)
make init
make up

# 4. Run the pipeline
make run          # stream events through Kafka → PySpark
make dbt-run      # run dbt models
make dashboard    # launch Streamlit locally

# Or visit the live dashboard directly:
# https://flowmarics.streamlit.app
```

---

## 📁 Project Structure

```
flowmatrix-pipeline/
├── dags/                  # Airflow DAG definitions
├── models/                # dbt models (7 total)
├── expectations/          # Great Expectations suites (34 tests)
├── spark_jobs/            # PySpark transformation scripts
├── kafka_producer/        # Event simulation & Kafka producer
├── streamlit_app/         # Dashboard source
├── assets/                # Architecture & dashboard screenshots
├── docker-compose.yml     # Full local stack
├── Makefile               # Convenience commands
└── README.md
```

---

## 🔮 Future Enhancements

- AWS deployment (Glue for Spark, MWAA for Airflow, MSK for Kafka)
- Incremental dbt models with snapshot tracking
- Great Expectations Data Docs published to S3
- Real-time alert system for data quality failures

---

## 📄 Licence

MIT — see [LICENSE](LICENSE) for details.
