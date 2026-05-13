#!/bin/bash

# Skript na kompiláciu LaTeX dokumentu podľa šablóny PEVŠ FI
# Použitie: ./compile.sh
#
# Zoznam skratiek: main.tex používa \makenoidxglossaries (bez makeglossaries).
# Na vygenerovanie glosára stačí viacnásobný pdflatex (tento skript 3×).

# Aktualizácia PATH pre LaTeX
eval "$(/usr/libexec/path_helper)"

# Pridanie štandardných ciest pre LaTeX na macOS
if [ -d "/Library/TeX/texbin" ]; then
    export PATH="/Library/TeX/texbin:$PATH"
fi

# Pridanie cesty pre BasicTeX (Homebrew)
if [ -d "/usr/local/texlive" ]; then
    export PATH="/usr/local/texlive/$(ls /usr/local/texlive | head -1)/bin/universal-darwin:$PATH"
fi

# Pridanie cesty pre BasicTeX (Homebrew ARM)
if [ -d "/opt/homebrew/texlive" ]; then
    export PATH="/opt/homebrew/texlive/$(ls /opt/homebrew/texlive 2>/dev/null | head -1)/bin/universal-darwin:$PATH"
fi

# Kontrola, či je pdflatex dostupný
if ! command -v pdflatex &> /dev/null; then
    echo "❌ Chyba: LaTeX nie je nainštalovaný!"
    echo ""
    echo "Pre inštaláciu LaTeX na macOS použite jeden z týchto spôsobov:"
    echo ""
    echo "1. BasicTeX (odporúčané - menšia inštalácia):"
    echo "   brew install --cask basictex"
    echo "   Potom reštartujte terminál alebo spustite:"
    echo "   eval \"\$(/usr/libexec/path_helper)\""
    echo ""
    echo "2. MacTeX (plná inštalácia - veľká, ale kompletná):"
    echo "   brew install --cask mactex"
    echo ""
    echo "Po inštalácii spustite:"
    echo "   ./install-packages.sh"
    echo ""
    echo "A potom znova:"
    echo "   ./compile.sh"
    exit 1
fi

echo "Kompilujem LaTeX dokument..."

echo "Krok 1/4: pdflatex..."
pdflatex -interaction=nonstopmode main.tex

if command -v biber &> /dev/null; then
    if [ -f "essentials/bibliography.bib" ]; then
        echo "Krok 2/4: biber..."
        biber main
    else
        echo "Krok 2/4: Preskakujem biber (essentials/bibliography.bib neexistuje)"
    fi
else
    echo "Krok 2/4: Preskakujem biber (nie je nainštalovaný)"
    echo "  Nainštalujte: sudo tlmgr install biber biblatex"
fi

echo "Krok 3/4: pdflatex..."
pdflatex -interaction=nonstopmode main.tex

echo "Krok 4/4: pdflatex (finálne odkazy, glosár, obsah)..."
pdflatex -interaction=nonstopmode main.tex

echo ""
if [ -f "main.pdf" ]; then
    echo "✅ Kompilácia dokončená! PDF súbor: main.pdf"
    ls -lh main.pdf
else
    echo "❌ Chyba: PDF súbor nebol vytvorený. Skontrolujte chybové hlásenia vyššie."
fi
