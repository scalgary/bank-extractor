FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y git curl zstd build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama as root
RUN curl -fsSL https://ollama.com/install.sh | sh

RUN useradd -m -s /bin/bash vscode
USER vscode

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/vscode/.local/bin:$PATH"

WORKDIR /workspace

# Ports
# 11434 — Ollama
# 8888  — JupyterLab
# 8000  — FastAPI
# 8501  — Streamlit
EXPOSE 11434 8888 8000 8501