#!/bin/bash

# Kompletný skript na inštaláciu LaTeX a kompiláciu projektu
# Použitie: ./setup-and-compile.sh

set -e  # Zastaví sa pri chybe

echo "🚀 Kompletná inštalácia a kompilácia LaTeX projektu"
echo "=================================================="
echo ""

# Farba pre výstup
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funkcia na kontrolu, či je príkaz dostupný
check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Aktualizácia PATH
eval "$(/usr/libexec/path_helper)"

# Pridanie štandardných ciest pre LaTeX na macOS
if [ -d "/Library/TeX/texbin" ]; then
    export PATH="/Library/TeX/texbin:$PATH"
fi

if [ -d "/usr/local/texlive" ]; then
    export PATH="/usr/local/texlive/$(ls /usr/local/texlive 2>/dev/null | head -1)/bin/universal-darwin:$PATH"
fi

if [ -d "/opt/homebrew/texlive" ]; then
    export PATH="/opt/homebrew/texlive/$(ls /opt/homebrew/texlive 2>/dev/null | head -1)/bin/universal-darwin:$PATH"
fi

# Krok 1: Kontrola Homebrew
echo "📦 Krok 1/4: Kontrola Homebrew..."
if ! check_command brew; then
    echo -e "${RED}❌ Homebrew nie je nainštalovaný!${NC}"
    echo "Nainštalujte ho: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi
echo -e "${GREEN}✅ Homebrew je nainštalovaný${NC}"
echo ""

# Krok 2: Kontrola a inštalácia LaTeX
echo "📦 Krok 2/4: Kontrola LaTeX..."
if check_command pdflatex; then
    echo -e "${GREEN}✅ LaTeX už je nainštalovaný${NC}"
    pdflatex --version | head -1
else
    echo -e "${YELLOW}⚠️  LaTeX nie je nainštalovaný${NC}"
    echo "Inštalujem BasicTeX (môže to trvať niekoľko minút)..."
    echo ""
    echo "💡 POZOR: Bude potrebné zadať sudo heslo!"
    echo ""
    
    if brew install --cask basictex; then
        echo -e "${GREEN}✅ BasicTeX bol nainštalovaný${NC}"
        echo ""
        echo "Aktualizujem PATH..."
        eval "$(/usr/libexec/path_helper)"
        
        # Pridanie cesty pre BasicTeX
        if [ -d "/Library/TeX/texbin" ]; then
            export PATH="/Library/TeX/texbin:$PATH"
        fi
        
        # Počkajme chvíľu, aby sa PATH aktualizoval
        sleep 2
        
        if ! check_command pdflatex; then
            echo -e "${YELLOW}⚠️  PATH sa ešte neaktualizoval. Reštartujte terminál alebo spustite:${NC}"
            echo "   eval \"\$(/usr/libexec/path_helper)\""
            echo ""
            echo "Potom znova spustite: ./setup-and-compile.sh"
            exit 1
        fi
    else
        echo -e "${RED}❌ Inštalácia BasicTeX zlyhala${NC}"
        echo "Skúste manuálne: brew install --cask basictex"
        exit 1
    fi
fi
echo ""

# Krok 3: Inštalácia LaTeX balíčkov
echo "📦 Krok 3/4: Inštalácia LaTeX balíčkov..."
if [ -f "./install-packages.sh" ]; then
    echo "Spúšťam install-packages.sh..."
    echo ""
    if bash ./install-packages.sh; then
        echo -e "${GREEN}✅ LaTeX balíčky boli nainštalované${NC}"
    else
        echo -e "${YELLOW}⚠️  Niektoré balíčky sa možno nepodarilo nainštalovať${NC}"
        echo "Môžete pokračovať, ale niektoré funkcie nemusia fungovať."
    fi
else
    echo -e "${YELLOW}⚠️  install-packages.sh nebol nájdený${NC}"
fi
echo ""

# Krok 4: Kompilácia dokumentu
echo "📄 Krok 4/4: Kompilácia LaTeX dokumentu..."
if [ -f "./compile.sh" ]; then
    echo "Spúšťam compile.sh..."
    echo ""
    if bash ./compile.sh; then
        echo ""
        echo -e "${GREEN}✅✅✅ Všetko je hotové! ✅✅✅${NC}"
        echo ""
        if [ -f "main.pdf" ]; then
            echo "PDF súbor bol úspešne vytvorený: main.pdf"
            ls -lh main.pdf
        fi
    else
        echo -e "${RED}❌ Kompilácia zlyhala${NC}"
        echo "Skontrolujte chybové hlásenia vyššie."
        exit 1
    fi
else
    echo -e "${RED}❌ compile.sh nebol nájdený${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Projekt je pripravený!${NC}"
