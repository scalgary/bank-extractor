#!/bin/bash

echo "🚀 Starting devcontainer setup..."
echo "📍 Current directory: $(pwd)"
echo "👤 Current user: $(whoami)"

# Install Python dependencies only
if [ ! -f "uv.lock" ]; then
    echo "📦 No uv.lock found - initializing project..."
    uv add pdfplumber pandas httpx rich python-dotenv fastapi uvicorn streamlit
    uv add --dev pytest pytest-cov ruff jupyterlab ipykernel
    echo "✅ Project initialized successfully!"
else
    echo "📦 Found uv.lock - syncing dependencies..."
    uv sync --extra dev
    echo "✅ Dependencies synced!"
fi

echo ""
echo "🎉 Setup complete!"
echo "💡 Now run: make pull-model"