#!/bin/bash

# Automatická inštalácia LaTeX s dialógom na zadanie hesla

echo "🚀 Automatická inštalácia LaTeX projektu"
echo ""

# Kontrola, či už nie je nainštalovaný
eval "$(/usr/libexec/path_helper)"
if [ -d "/Library/TeX/texbin" ]; then
    export PATH="/Library/TeX/texbin:$PATH"
fi

if command -v pdflatex &> /dev/null; then
    echo "✅ LaTeX už je nainštalovaný!"
    pdflatex --version | head -1
    echo ""
    echo "Pokračujem s inštaláciou balíčkov..."
    ./install-packages.sh
    echo ""
    echo "Kompilujem dokument..."
    ./compile.sh
    exit 0
fi

# Zobrazenie dialógu na zadanie hesla (macOS)
echo "💡 Zobrazí sa dialóg na zadanie administrátorského hesla"
echo ""

# Použiť osascript na získanie hesla
PASSWORD=$(osascript -e 'Tell application "System Events" to display dialog "Zadajte administrátorské heslo pre inštaláciu BasicTeX:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)

if [ -z "$PASSWORD" ]; then
    echo "❌ Heslo nebolo zadané alebo dialóg bol zrušený"
    echo ""
    echo "Spustite manuálne:"
    echo "  brew install --cask basictex"
    exit 1
fi

# Inštalácia BasicTeX s hesлом
echo "Inštalujem BasicTeX..."
echo "$PASSWORD" | sudo -S brew install --cask basictex 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ BasicTeX bol nainštalovaný!"
    echo ""
    echo "Aktualizujem PATH..."
    eval "$(/usr/libexec/path_helper)"
    
    if [ -d "/Library/TeX/texbin" ]; then
        export PATH="/Library/TeX/texbin:$PATH"
    fi
    
    # Počkaj chvíľu
    sleep 2
    
    echo ""
    echo "Inštalujem LaTeX balíčky..."
    echo "$PASSWORD" | sudo -S bash ./install-packages.sh 2>&1
    
    echo ""
    echo "Kompilujem dokument..."
    ./compile.sh
else
    echo "❌ Inštalácia zlyhala"
    exit 1
fi
