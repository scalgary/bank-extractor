# bank-extractor — Memory

Living document. Updated at each phase. Records exact steps taken.

---

## Prerequisites

- macOS
- Docker Desktop
- VSCode + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- GitHub account
- GitHub CLI (`gh`) — authenticated via `gh auth login`
- `uv` — installed via `pip install uv`

---

## Phase 0 — GitHub Setup

### Goal
Create empty public repo and clone locally.

### Steps taken

```bash
gh repo create bank-extractor --public --clone
cd bank-extractor
```

### Result
Empty repo cloned locally. Ready to build project structure.

---

## Phase 1 — Project Structure ✅

### Goal
Set up dev environment with devcontainer, uv, and all config files.

### Steps taken

#### 1. Create devcontainer files

Create `.devcontainer/` folder with 3 files:
- `Dockerfile` — base image, installs Ollama + uv
- `devcontainer.json` — VSCode config, ports, extensions
- `setup.sh` — installs Python deps only (no Ollama)

Create `Makefile` 

#### 2. Create `.env` BEFORE opening container

⚠️ Required — container won't start without it.

```bash
touch .env
```

Add content:
```
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=phi3:mini
JUPYTER_PORT=8888
API_PORT=8000
UI_PORT=8501
```

#### 3. Open in VSCode

```bash
code .
```

VSCode popup → click **"Reopen in Container"**

Or: `CMD+SHIFT+P → "Dev Containers: Reopen in Container"`

⚠️ First build takes ~10-15 min.

#### 4. Once inside container — start Ollama and pull model

```bash
make serve        # starts ollama serve in background
make pull-model   # pulls phi3:mini (run once)
```

⚠️ First time Ollama runs it generates a private key — normal message:
```
Couldn't find '/home/vscode/.ollama/id_ed25519'. Generating new private key.
```

#### 5. Verify

```bash
ollama list       # should show phi3:mini
uv run python --version
```

### Result ✅
Container running, Ollama serving, phi3:mini pulled and ready.

---

### Errors encountered

#### ❌ Error: `.env` file missing
```
docker: open .env: no such file or directory
```
**Fix:** `touch .env` before reopening container.

#### ❌ Error: `postCreateCommand` failing with Ollama
**Cause:** Ollama not ready during `postCreateCommand` execution.  
**Fix:** Removed Ollama from `setup.sh`. Use `make serve` + `make pull-model` manually after container starts.

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