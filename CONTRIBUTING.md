# 🤝 Contributing to FlowMatrix

Thank you for your interest in contributing to **FlowMatrix**! This document outlines how to get started, submit pull requests, and follow our coding standards.

---

## 📋 Table of Contents

* [Code of Conduct](#code-of-conduct)
* [Getting Started](#getting-started)
* [Development Setup](#development-setup)
* [Project Structure](#project-structure)
* [Running Tests](#running-tests)
* [Code Style](#code-style)
* [Submitting a Pull Request](#submitting-a-pull-request)
* [Reporting Issues](#reporting-issues)

---

## Code of Conduct

Please be respectful and constructive in all interactions. We follow the Contributor Covenant Code of Conduct.

---

## Getting Started

1. **Fork** the repository on GitHub.
2. **Clone** your fork locally:

```bash
git clone https://github.com/<your-username>/flowmatrix-pipeline.git
cd flowmatrix-pipeline
```

3. **Add the upstream remote**:

```bash
git remote add upstream https://github.com/<your-github-username>/flowmatrix-pipeline.git
```

4. **Create a feature branch**:

```bash
git checkout -b feat/your-feature-name
```

---

## Development Setup

### Option A — Local Python

```bash
python -m venv .venv

# Windows
.venv\Scripts\activate

# Linux/macOS
source .venv/bin/activate

pip install -r requirements-dev.txt

pytest tests/test_producer.py tests/test_simple_consumer.py -v
```

### Option B — Docker

```bash
cp .env.example .env

make up

make simple-run
make dbt-run
```

### Option C — GitHub Codespaces

Open the repository in **GitHub Codespaces** to automatically install dependencies and configure the development environment.

---

## Project Structure

```text
flowmatrix-pipeline/
├── ingestion/
├── processing/
├── dbt_project/
├── dags/
├── quality/
├── dashboard/
├── tests/
├── scripts/
├── docker/
└── docker-compose.yml
```

---

## Running Tests

```bash
pytest tests/test_producer.py tests/test_simple_consumer.py -v

pytest tests/test_producer.py tests/test_simple_consumer.py \
    --cov=ingestion --cov=processing --cov-report=term-missing

ruff check ingestion/ processing/ dags/ quality/ dashboard/ tests/

make lint && make test
```

---

## Code Style

* Follow **PEP 8**
* Format code using **Black**
* Lint using **Ruff**
* Use type hints for all public functions
* Write Google-style docstrings
* Organize imports as Standard Library → Third-Party → Local
* Follow dbt best practices for SQL models

Optional pre-commit hooks:

```bash
pip install pre-commit
pre-commit install
```

---

## Submitting a Pull Request

1. Sync with upstream:

```bash
git fetch upstream
git rebase upstream/main
```

2. Add tests for new functionality.

3. Run all checks:

```bash
make lint && make test
```

4. Commit using Conventional Commits:

```text
feat: add multi-topic Kafka consumer
fix: handle null customer_id
docs: update dbt documentation
test: add edge-case unit tests
```

5. Push your branch and open a Pull Request.

6. Link related issues and request a review.

All CI checks must pass before merging.

---

## Reporting Issues

Please use GitHub Issues to report bugs or request new features.

Include:

* Operating System
* Python Version
* Steps to reproduce
* Expected behavior
* Actual behavior
* Relevant logs or screenshots

Recommended labels:

* bug
* enhancement
* documentation
* question

---

<div align="center">

### 🚀 Happy Coding!

**⚡ FlowMatrix — Building Reliable Data Pipelines**

</div>
