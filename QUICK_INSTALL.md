# Rýchla inštalácia LaTeX projektu

## Krok 1: Inštalácia BasicTeX

Spustite v termináli (bude potrebné zadať sudo heslo):

```bash
brew install --cask basictex
```

Po inštalácii reštartujte terminál alebo spustite:

```bash
eval "$(/usr/libexec/path_helper)"
```

## Krok 2: Automatická inštalácia balíčkov a kompilácia

Spustite:

```bash
./setup-and-compile.sh
```

Alebo manuálne:

```bash
# 1. Inštalácia balíčkov
./install-packages.sh

# 2. Kompilácia
./compile.sh
```

## Alternatíva: Všetko naraz

Ak chcete všetko spraviť naraz, spustite:

```bash
brew install --cask basictex && \
eval "$(/usr/libexec/path_helper)" && \
./install-packages.sh && \
./compile.sh
```
