#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

compile() {
  echo
  echo "==> $(date '+%Y-%m-%d %H:%M:%S') Kompilujem..."
  ./compile.sh
  echo "==> Hotovo: main.pdf"
}

if command -v fswatch >/dev/null 2>&1; then
  echo "Sledujem zmeny (fswatch) v: main.tex essentials/ examples/"
  echo "Ukonči: Ctrl+C"
  # -o: emitne udalosť (1 číslo) pri zmene; debouncing spraví timeout.
  fswatch -o -r main.tex essentials examples | while read -r _; do
    # jednoduchý debounce: počkaj, či neprichádzajú ďalšie zmeny
    sleep 0.3
    while read -r -t 0.2 _; do :; done || true
    compile || true
  done
else
  echo "fswatch nie je nainštalovaný — použijem polling (bez závislostí)."
  echo "Sledujem zmeny v: main.tex essentials/ examples/"
  echo "Ukonči: Ctrl+C"

  last_sig=""
  while true; do
    # podpis poslednej zmeny (mtime) všetkých relevantných súborov
    sig="$(
      {
        stat -f '%m %N' main.tex 2>/dev/null || true
        find essentials examples -type f \( -name '*.tex' -o -name '*.bib' -o -name '*.png' -o -name '*.jpg' -o -name '*.pdf' \) -print0 2>/dev/null \
          | xargs -0 stat -f '%m %N' 2>/dev/null || true
      } | LC_ALL=C sort | shasum | awk '{print $1}'
    )"

    if [[ "$sig" != "$last_sig" ]]; then
      # prvý prechod iba inicializuj, aby sa nekompilovalo hneď po štarte
      if [[ -n "$last_sig" ]]; then
        compile || true
      fi
      last_sig="$sig"
    fi
    sleep 1
  done
fi

