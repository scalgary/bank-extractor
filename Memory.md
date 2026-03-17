# bank-extractor — Memory

Living document. Updated at each phase. Records exact steps taken.

---

## Project Goal

Extract transactions from PDF bank statements (same bank, consistent format) and export to tagged CSV. Fully private — no data leaves the machine.

**Stack:**
| Layer | Tool |
|---|---|
| Dev environment | VSCode devcontainer |
| Package manager | `uv` |
| PDF extraction | `pdfplumber` |
| LLM (local) | Ollama + `phi3:mini` (dev) → `mistral:7b` (RunPod) |
| CSV output | `pandas` |
| API (future) | FastAPI |
| UI (future) | Streamlit |
| Tests | pytest |
| Linter | ruff |

---

## Project Structure

```
bank-extractor/
├── .devcontainer/
│   ├── Dockerfile           # base image: python:3.12-slim + Ollama + uv
│   ├── devcontainer.json    # VSCode config, ports, extensions, postStartCommand
│   └── setup.sh             # installs Python deps via uv (run once on build)
├── docs/
│   ├── memory.md            # this file — single source of truth
│   ├── decisions.md         # why we made each architectural choice
│   ├── runpod.md            # migration guide for RunPod
│   └── history/             # shell history snapshots per session (gitignored)
├── logs/                    # runtime logs (gitignored)
├── scripts/
│   ├── generate_fake_pdf.py # generates fake bank statement for testing (run manually)
│   └── reset.sh             # clears input/, output/, logs/
├── app/
│   └── process.py           # core logic: PDF → extract → tag → CSV
├── api/
│   └── main.py              # FastAPI (Phase 4)
├── ui/
│   └── app.py               # Streamlit (Phase 4)
├── notebooks/
│   └── explore.ipynb        # Jupyter exploration
├── tests/
│   ├── fixtures/
│   │   ├── input/           # fake PDF committed to git
│   │   └── output/          # expected CSV committed to git
│   └── test_process.py
├── input/                   # real PDFs — gitignored
├── output/                  # real CSVs — gitignored
├── CHANGELOG.md             # what changed per version
├── Makefile                 # shortcuts for common commands
├── README.md                # short intro, points to memory.md
├── .env                     # real values — gitignored
├── .env.example             # template — committed to git
├── .gitignore
├── pyproject.toml           # uv deps: main + dev group (created via uv init)
└── docker-compose.yml       # prod only (Phase 4+)
```

**Key rules:**
- `input/` and `output/` are gitignored — real bank data never touches GitHub
- `tests/fixtures/` contains fake data — committed to git for CI
- `.env` is gitignored — copy from `.env.example` on new machine

---

## Environment Variables (`.env`)

```
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=phi3:mini
INPUT_DIR=./input
OUTPUT_DIR=./output
JUPYTER_PORT=8888
API_PORT=8000
UI_PORT=8501
APP_ENV=dev   # dev | prod
```

On RunPod: change `INPUT_DIR` and `OUTPUT_DIR` to `/workspace/input` and `/workspace/output`, and `APP_ENV=prod`.

---

## Makefile Commands

```bash
make serve        # start Ollama server in background
make pull-model   # pull model defined in OLLAMA_MODEL (run once)
make run          # run app/process.py
make jupyter      # start JupyterLab on port 8888
make test         # run pytest with coverage
make lint         # run ruff
make reset        # clear input/, output/, logs/
make session-end  # save bash history and prompt to exit container
```

---

## Git Workflow

Always work on a branch — never commit directly to `main`.

⚠️ Exception: Phase 0 and Phase 1 were committed directly to `main` (repo initialization). From Phase 2 onwards, always use branches.

```bash
# Start of session
git checkout main
git pull
git checkout -b phase/2-local-mvp   # or fix/description

# End of session
git add .
git commit -m "feat: description"
git push -u origin phase/2-local-mvp

# Merge when done
git checkout main
git merge phase/2-local-mvp
git push
```

---

## Session Management

### End of session checklist

```bash
# 1. Inside container — save console history
make session-end

# 2. Exit container
# CMD+SHIFT+P → "Dev Containers: Reopen Folder Locally"

# 3. Commit from local terminal
git add .
git commit -m "your message"
git push

# 4. Prune Docker to free space
docker system prune -a
```

⚠️ Always exit container before committing and pruning.

---

## Prerequisites

- macOS
- Docker Desktop
- VSCode + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- GitHub account
- GitHub CLI (`gh`) — authenticated via `gh auth login`
- `uv` — installed via `pip install uv`

---

## Phases

| Phase | Status | Description |
|---|---|---|
| 0 | ✅ | GitHub repo created |
| 1 | ✅ | Devcontainer + Ollama + phi3:mini working |
| 1.5 | ✅ | Dev environment hardening (Jupyter, APP_ENV, session-end) |
| 2 | 🔜 | Local MVP: fake PDF → CSV with tags |
| 3 | ⏳ | Jupyter exploration + prompt tuning |
| 4 | ⏳ | FastAPI + Streamlit |
| 5 | ⏳ | RunPod migration + mistral:7b |

---

## Phase 0 — GitHub Setup ✅

**Branch:** `main` (exception — empty repo init)

```bash
gh repo create bank-extractor --public --clone
cd bank-extractor
```

---

## Phase 1 — Project Structure ✅

**Branch:** `main` (exception — initial project structure)

### Steps taken

#### 1. Create devcontainer files
- `Dockerfile` — python:3.12-slim + Ollama + uv + build-essential
- `devcontainer.json` — ports 11434, 8888, 8000, 8501 forwarded
- `setup.sh` — installs Python deps only

#### 2. Create `.env` BEFORE opening container

⚠️ Required — container won't start without it.

```bash
touch .env
touch .env.example
# then fill in values from Environment Variables section above
```

#### 3. Open in VSCode

```bash
code .
# VSCode popup → "Reopen in Container"
# OR: CMD+SHIFT+P → "Dev Containers: Reopen in Container"
```

⚠️ First build ~10-15 min.

#### 4. Start Ollama and pull model

```bash
make serve        # start ollama in background
make pull-model   # pull phi3:mini (once)
```

⚠️ Normal first-run message:
```
Couldn't find '/home/vscode/.ollama/id_ed25519'. Generating new private key.
```

#### 5. Verify

```bash
ollama list
uv run python --version
```

### Errors encountered

#### ❌ `.env` file missing
```
docker: open .env: no such file or directory
```
**Fix:** `touch .env` before reopening container.

#### ❌ `postCreateCommand` failing with Ollama
**Cause:** Ollama not ready during build.
**Fix:** Removed from `setup.sh`. Use `make serve` + `make pull-model` manually.

---

## Phase 1.5 — Dev Environment Hardening ✅

**Branch:** `main` (exception — dev tooling only)

### Changes made

#### 1. `APP_ENV` variable added
- Controls dev vs prod behavior in `setup.sh`
- Added to `.env` and `.env.example`
- `dev` → installs Jupyter + dev deps
- `prod` → skips dev deps

#### 2. `setup.sh` updated
- Checks `APP_ENV` before installing dev dependencies
- Fixed `uv sync --extra dev` → `uv sync --group dev`
- Dev deps (jupyterlab, ipykernel, pytest, ruff) only installed when `APP_ENV=dev`

#### 3. `pyproject.toml` created
- Run `uv init` inside container (was missing — caused Jupyter install failure)
- ⚠️ Must exist before `setup.sh` can install deps

#### 4. `make session-end` added to Makefile
- Saves bash history to `docs/history/YYYY-MM-DD_session.sh`
- Uses `history -w` (not `fc` — not available in sh)

#### 5. `devcontainer.json` updated
- Added `"jupyter.jupyterServerType": "local"`
- `postStartCommand`: `ollama serve & make jupyter`
- `"target": "dev"` considered but dropped — no real benefit with single Dockerfile

### Errors encountered

#### ❌ `fc: not found` in Makefile
**Cause:** `fc` is bash-only, Makefile uses `sh`.
**Fix:** Use `bash -c 'history -w ...'` instead.

#### ❌ `uv sync --extra dev` invalid
**Fix:** Use `uv sync --group dev`.

#### ❌ Jupyter not found after setup
**Cause:** `pyproject.toml` was missing — `uv init` was never run.
**Fix:** Run `uv init` first, then `bash .devcontainer/setup.sh`.

---

## Phase 2 — Local MVP

_not started_

---

## Phase 3 — Exploration (Jupyter)

_not started_

---

## Phase 4 — API + UI (FastAPI + Streamlit)

_not started_

---

## Phase 5 — RunPod Migration

_not started_