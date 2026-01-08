# Inštalácia LaTeX balíčkov pre bakalársku prácu

## Krok 1: Inštalácia potrebných LaTeX balíčkov

Pre správnu kompiláciu dokumentu potrebujete nainštalovať niekoľko LaTeX balíčkov. Spustite:

```bash
./install-packages.sh
```

Tento skript nainštaluje:
- Slovenský jazykový balíček (`collection-langslovak`)
- Font balíčky (`newtxtext`, `newtxmath`)
- Balíčky pre glosár (`glossaries`, `makeindex`)
- Balíčky pre bibliografiu (`biblatex`, `biblatex-iso690`, `biber`)

**POZOR:** Tento proces vyžaduje sudo heslo a môže trvať niekoľko minút.

## Krok 2: Úprava metadát v main.tex

Po inštalácii balíčkov upravte v súbore `main.tex` nasledujúce informácie:

- `\title{Názov bakalárskej práce}` - názov vašej práce
- `\author{Janko Mrkvička}` - vaše meno
- `\def\uid{FI-123456-12345}` - váš študentský ID
- `\def\supervisor{doc. RNDr. Severín Hrot, PhD.}` - meno vášho školiteľa
- `\def\consultant{Mgr. Ignác Novák}` - meno konzultanta (ak ho máte, inak odkomentujte riadok v `essentials/titlepage-alt.tex`)
- `\def\thesisyear{2026}` - rok vypracovania práce

## Krok 3: Nahradenie súborov

Nahraďte súbor `essentials/assignment.pdf` vaším zadaniem práce.

Upravte podľa potreby:
- `essentials/abstract.tex` - abstrakt v slovenčine a angličtine
- `essentials/acknowledgment.tex` - poďakovanie
- `essentials/declaration.tex` - čestné prehlásenie
- `essentials/bibliography.bib` - bibliografia (štandard STN ISO 690)

## Krok 4: Kompilácia dokumentu

Po inštalácii balíčkov a úprave metadát skompilujte dokument:

```bash
./compile.sh
```

Alebo manuálne:

```bash
pdflatex main
makeglossaries main
biber main
pdflatex main
pdflatex main
```

## Štruktúra projektu

```
.
├── essentials/            # Základné súbory
│   ├── abstract.tex       # Abstrakt
│   ├── acknowledgment.tex # Poďakovanie
│   ├── acronyms.tex       # Zoznam skratiek
│   ├── appendices.tex     # Prílohy
│   ├── bibliography.bib   # Bibliografia
│   ├── declaration.tex    # Čestné prehlásenie
│   ├── titlepage.tex      # Titulná strana
│   ├── titlepage-alt.tex  # Alternatívna titulná strana
│   └── assignment.pdf     # Zadanie práce
├── examples/              # Príklady použitia
│   └── examples.tex
├── main.tex               # Hlavný dokument
├── compile.sh             # Skript na kompiláciu
└── install-packages.sh    # Skript na inštaláciu balíčkov
```

## Ďalšie informácie

Podrobnejšie informácie o použití šablóny nájdete v priečinku `thesis-template-main/README.md`.

