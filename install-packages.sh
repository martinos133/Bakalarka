#!/bin/bash

# Skript na inštaláciu potrebných LaTeX balíčkov pre šablónu PEVŠ FI
# Použitie: ./install-packages.sh
# POZOR: Vyžaduje sudo heslo!

echo "Inštalujem potrebné LaTeX balíčky..."
echo "Tento proces môže trvať niekoľko minút..."
echo ""

# Aktualizácia PATH
eval "$(/usr/libexec/path_helper)"

# Aktualizácia tlmgr
echo "1. Aktualizujem tlmgr..."
sudo tlmgr update --self

# Inštalácia potrebných balíčkov
echo ""
echo "2. Inštalujem jazykové balíčky..."
sudo tlmgr install collection-langslovak

echo ""
echo "3. Inštalujem font balíčky..."
sudo tlmgr install newtxtext newtxmath

echo ""
echo "4. Inštalujem balíčky pre glosár..."
sudo tlmgr install glossaries makeindex

echo ""
echo "5. Inštalujem balíčky pre bibliografiu..."
sudo tlmgr install biblatex biblatex-iso690 biber

echo ""
echo "✅ Inštalácia dokončená!"
echo "Teraz môžete skompilovať dokument pomocou: ./compile.sh"

