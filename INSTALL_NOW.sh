#!/bin/bash

# Jednoduchý skript na inštaláciu - spustite v termináli a zadajte heslo keď sa spýta

set -e

echo "🚀 Inštalácia LaTeX projektu"
echo "============================"
echo ""

# Krok 1: Kontrola LaTeX
eval "$(/usr/libexec/path_helper)"
if [ -d "/Library/TeX/texbin" ]; then
    export PATH="/Library/TeX/texbin:$PATH"
fi

if command -v pdflatex &> /dev/null; then
    echo "✅ LaTeX už je nainštalovaný!"
    pdflatex --version | head -1
else
    echo "📦 Inštalujem BasicTeX..."
    echo "   (Bude potrebné zadať sudo heslo)"
    brew install --cask basictex
    
    echo ""
    echo "⏳ Čakám na dokončenie inštalácie..."
    sleep 3
    
    echo "🔄 Aktualizujem PATH..."
    eval "$(/usr/libexec/path_helper)"
    
    if [ -d "/Library/TeX/texbin" ]; then
        export PATH="/Library/TeX/texbin:$PATH"
    fi
    
    # Počkaj ešte chvíľu
    sleep 2
    
    if ! command -v pdflatex &> /dev/null; then
        echo "⚠️  PATH sa ešte neaktualizoval. Reštartujte terminál alebo spustite:"
        echo "   eval \"\$(/usr/libexec/path_helper)\""
        echo "   Potom znova spustite tento skript."
        exit 1
    fi
    
    echo "✅ BasicTeX bol nainštalovaný!"
fi

echo ""
echo "📦 Inštalujem LaTeX balíčky..."
echo "   (Bude potrebné zadať sudo heslo)"
bash ./install-packages.sh

echo ""
echo "📄 Kompilujem dokument..."
bash ./compile.sh

echo ""
echo "✅✅✅ Všetko je hotové! ✅✅✅"
if [ -f "main.pdf" ]; then
    echo ""
    echo "PDF súbor: main.pdf"
    ls -lh main.pdf
fi
