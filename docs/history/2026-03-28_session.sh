    1  quarto render Process_GIC.qmd
    2  uv run quarto render Process_GIC.qmd
    3  ls
    4  ls 
    5  quarto render Process_GIC.qmd
    6  touch .gitignore
    7  git diff main..gic --name-only
    8  git stash
    9  git checkout main
   10  git diff main..gic --name-only
   11  git checkout gic --.devcontainer/*
   12  git diff main..gic --name-only
   13  git checkout gic -- .devcontainer/*
   14  git diff main..gic --name-only
   15  git checkout gic -- .env
   16  git checkout gic -- .gitignore
   17  git checkout gic -- pyproject.toml
   18  git checkout gic -- uv.lock
   19  git push
   20  git switch gic
   21  git status
   22  git stash clear
   23  git stash push -m "Process GIC"
   24  git stash list
   25  git stash push -u -m "Process GIC"
   26  git stash list
   27  git checkout main
   28  git checkout gic -- .gitignore
   29  git diff main..gic --name-only
   30  git rm --cached data/*.csv
   31  git rm --cached data/lookup_gic.csv
   32  git commit -m "remove data/file.csv from tracking"
   33  git push
   34  git checkout gic
   35  git rm --cached data/lookup_gic.csv
   36  git rm --cached data/gic_bronze.csv
   37  git commit -m "untrack file"
   38  git status
   39  git stash list
   40  git stash pop
   41  quarto render Process_GIC.qmd
   42  git status
   43  git push
   44  make session-end
   45  echo $HISTFILE
   46  history -w
   47  ls ~/.bash_history
   48  make session-end
   49  history
   50  history -w && make session-end
   51  history -w
   52  history
   53  history > docs/history/$$(date +%Y-%m-%d)_session.sh
   54  history > docs/history/$(date +%Y-%m-%d)_session.sh
