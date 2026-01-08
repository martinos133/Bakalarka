#!/bin/bash

# Skript na kompiláciu LaTeX dokumentu podľa šablóny PEVŠ FI
# Použitie: ./compile.sh

# Aktualizácia PATH pre LaTeX
eval "$(/usr/libexec/path_helper)"

echo "Kompilujem LaTeX dokument..."

# Kompilácia dokumentu (podľa postupu z README)
echo "Krok 1/3: Prvá kompilácia pdflatex..."
pdflatex -interaction=nonstopmode main.tex

# Skontrolujeme, či sú potrebné nástroje dostupné
if command -v makeglossaries &> /dev/null; then
    echo "Krok 2/5: Generovanie glosára..."
    makeglossaries main
    HAS_GLOSSARIES=1
else
    echo "Preskakujem generovanie glosára (makeglossaries nie je dostupný)"
    echo "  Nainštalujte: sudo tlmgr install glossaries"
    HAS_GLOSSARIES=0
fi

if command -v biber &> /dev/null; then
    if [ -f "essentials/bibliography.bib" ]; then
        echo "Krok 3/5: Generovanie bibliografie..."
        biber main
        HAS_BIBLIO=1
    else
        echo "Preskakujem generovanie bibliografie (bibliography.bib neexistuje)"
        HAS_BIBLIO=0
    fi
else
    echo "Preskakujem generovanie bibliografie (biber nie je dostupný)"
    echo "  Nainštalujte: sudo tlmgr install biber biblatex biblatex-iso690"
    HAS_BIBLIO=0
fi

if [ $HAS_GLOSSARIES -eq 1 ] || [ $HAS_BIBLIO -eq 1 ]; then
    echo "Krok 4/5: Druhá kompilácia pdflatex..."
    pdflatex -interaction=nonstopmode main.tex
    
    echo "Krok 5/5: Finálna kompilácia pdflatex..."
    pdflatex -interaction=nonstopmode main.tex
else
    echo "Krok 2/2: Druhá kompilácia pdflatex (bez glosára a bibliografie)..."
    pdflatex -interaction=nonstopmode main.tex
fi

echo ""
if [ -f "main.pdf" ]; then
    echo "✅ Kompilácia dokončená! PDF súbor: main.pdf"
    ls -lh main.pdf
else
    echo "❌ Chyba: PDF súbor nebol vytvorený. Skontrolujte chybové hlásenia vyššie."
fi
