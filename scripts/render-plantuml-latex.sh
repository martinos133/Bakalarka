#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Použitie: $0 <file.puml> [--preamble]"
  exit 1
fi

IN="$1"
shift || true

OUT_DIR="diagrams/out"
mkdir -p "$OUT_DIR"

if ! command -v plantuml >/dev/null 2>&1; then
  echo "Chýba 'plantuml'. Pozri diagrams/README.md (inštalácia)."
  exit 1
fi

FMT="latex:nopreamble"
if [[ "${1:-}" == "--preamble" ]]; then
  FMT="latex"
fi

echo "Generujem TikZ LaTeX z: $IN"
plantuml "-t${FMT}" -o "$(cd "$OUT_DIR" && pwd)" "$IN"

echo "Hotovo. Výstup je v: $OUT_DIR"

