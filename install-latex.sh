#!/bin/bash

# Skript na inštaláciu LaTeX na macOS
# Použitie: ./install-latex.sh

echo "🔧 Inštalácia LaTeX na macOS"
echo ""

# Kontrola, či je Homebrew nainštalovaný
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew nie je nainštalovaný!"
    echo ""
    echo "Najprv nainštalujte Homebrew:"
    echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo "✅ Homebrew je nainštalovaný"
echo ""

# Kontrola, či už nie je LaTeX nainštalovaný
if command -v pdflatex &> /dev/null; then
    echo "✅ LaTeX už je nainštalovaný!"
    echo "   Verzia: $(pdflatex --version | head -1)"
    echo ""
    echo "Môžete pokračovať s inštaláciou balíčkov:"
    echo "   ./install-packages.sh"
    exit 0
fi

echo "Vyberte typ inštalácie:"
echo "1) BasicTeX (odporúčané - menšia inštalácia, ~100MB)"
echo "2) MacTeX (plná inštalácia, ~4GB)"
echo ""
read -p "Vaša voľba (1 alebo 2): " choice

case $choice in
    1)
        echo ""
        echo "Inštalujem BasicTeX..."
        brew install --cask basictex
        echo ""
        echo "✅ BasicTeX bol nainštalovaný!"
        echo ""
        echo "⚠️  DÔLEŽITÉ: Reštartujte terminál alebo spustite:"
        echo "   eval \"\$(/usr/libexec/path_helper)\""
        echo ""
        echo "Potom spustite:"
        echo "   ./install-packages.sh"
        ;;
    2)
        echo ""
        echo "Inštalujem MacTeX (môže to trvať dlhšie)..."
        brew install --cask mactex
        echo ""
        echo "✅ MacTeX bol nainštalovaný!"
        echo ""
        echo "⚠️  DÔLEŽITÉ: Reštartujte terminál alebo spustite:"
        echo "   eval \"\$(/usr/libexec/path_helper)\""
        echo ""
        echo "Potom spustite:"
        echo "   ./install-packages.sh"
        ;;
    *)
        echo "❌ Neplatná voľba. Ukončujem."
        exit 1
        ;;
esac
