#!/bin/bash

echo "🚀 Starting devcontainer setup..."
echo "📍 Current directory: $(pwd)"
echo "👤 Current user: $(whoami)"
echo "🌍 Environment: ${APP_ENV:-dev}"

if [ ! -f "uv.lock" ]; then
    echo "📦 No uv.lock found - initializing project..."
    uv add pdfplumber pandas httpx rich python-dotenv fastapi uvicorn streamlit
    
    if [ "${APP_ENV:-dev}" = "dev" ]; then
        echo "🔧 Dev mode - adding dev dependencies..."
        uv add --dev pytest pytest-cov ruff jupyterlab ipykernel
    fi
    echo "✅ Project initialized!"
else
    echo "📦 Found uv.lock - syncing..."
    if [ "${APP_ENV:-dev}" = "dev" ]; then
        echo "🔧 Dev mode - adding dev dependencies..."

        uv sync --group dev
        uv run python -m ipykernel install --user --name="${PROJECT_NAME}"  --display-name "${PROJECT_NAME}" \

    else
        uv sync
    fi
    echo "✅ Dependencies synced!"
fi

echo "export QUARTO_PYTHON=/workspaces/${PROJECT_NAME}/.venv/bin/python" >> ~/.bashrc
echo ""
echo "🎉 Setup complete!"
echo "💡 Now run: make pull-model"