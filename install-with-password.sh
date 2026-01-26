#!/bin/bash

# Skript na inštaláciu BasicTeX s možnosťou zadania hesla cez dialóg

echo "🔧 Inštalácia BasicTeX"
echo ""

# Kontrola, či už nie je nainštalovaný
eval "$(/usr/libexec/path_helper)"
if [ -d "/Library/TeX/texbin" ]; then
    export PATH="/Library/TeX/texbin:$PATH"
fi

if command -v pdflatex &> /dev/null; then
    echo "✅ LaTeX už je nainštalovaný!"
    pdflatex --version | head -1
    exit 0
fi

# Skúsiť inštalovať BasicTeX
echo "Inštalujem BasicTeX..."
echo "Bude potrebné zadať sudo heslo v dialógu."
echo ""

# Použiť osascript na získanie hesla (voliteľné)
# Alebo jednoducho spustiť brew install
brew install --cask basictex

# Počkaj na dokončenie inštalácie
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ BasicTeX bol nainštalovaný!"
    echo ""
    echo "Aktualizujem PATH..."
    eval "$(/usr/libexec/path_helper)"
    
    if [ -d "/Library/TeX/texbin" ]; then
        export PATH="/Library/TeX/texbin:$PATH"
    fi
    
    echo "✅ Hotovo! Teraz môžete spustiť: ./install-packages.sh"
else
    echo "❌ Inštalácia zlyhala. Skúste manuálne: brew install --cask basictex"
    exit 1
fi
