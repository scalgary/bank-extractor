.PHONY: help pull-model serve test lint jupyter run reset session-end

help:
	@echo "Available commands:"
	@echo "  make pull-model   Pull Ollama model (run once)"
	@echo "  make serve        Start Ollama server"
	@echo "  make run          Run PDF extraction pipeline"
	@echo "  make jupyter      Start JupyterLab"
	@echo "  make test         Run tests"
	@echo "  make lint         Run ruff linter"
	@echo "  make reset        Clear input, output, logs"
	@echo "  make session-end  Save history and exit container"

pull-model:
	ollama pull $${OLLAMA_MODEL:-phi3:mini}

serve:
	ollama serve &

run:
	uv run python app/process.py

jupyter:
	uv run jupyter lab --ip=0.0.0.0 --port=8888 --no-browser

test:
	uv run pytest tests/ -v --cov=app

lint:
	uv run ruff check .

reset:
	rm -rf input/* output/* logs/*
	@echo "✅ Reset complete"

session-end:
	@mkdir -p docs/history
	@bash -c 'history -w docs/history/$$(date +%Y-%m-%d)_session.sh'
	@echo "✅ History saved"
	@echo "👉 Now: CMD+SHIFT+P → Reopen Folder Locally"