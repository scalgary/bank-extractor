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
        uv sync --group dev
    else
        uv sync
    fi
    echo "✅ Dependencies synced!"
fi

echo ""
echo "🎉 Setup complete!"
echo "💡 Now run: make pull-model"