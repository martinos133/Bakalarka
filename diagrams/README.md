# PlantUML diagramy do LaTeXu (TikZ)

PlantUML vie generovať výstup priamo do LaTeXu cez TikZ (`-tlatex`). To sa dá pekne vložiť do bakalárky ako čistý vektor.

## Požiadavky

- `plantuml` (verzia **>= 7997** kvôli `-tlatex`)
- Java runtime (JRE/JDK)
- (odporúčané) `graphviz` (`dot`) – niektoré typy diagramov to vyžadujú

## Inštalácia na macOS (Homebrew)

Ak ti `brew` hlási, že `/opt/homebrew` nie je zapisovateľné, oprav vlastníctvo (Homebrew ti vypíše presný príkaz).

Potom nainštaluj:

```bash
brew install temurin graphviz plantuml
```

Over:

```bash
plantuml -version
dot -V
java -version
```

## Generovanie LaTeX (TikZ)

Vytvor `.puml` a vyexportuj do `.tex`:

```bash
./scripts/render-plantuml-latex.sh diagrams/example-class.puml
```

Výstup bude v `diagrams/out/`:

- `*.tex` (predvolene **bez preambuly** – vhodné na `\input{...}` do tvojej práce)

## Vloženie do `main.tex`

1. Do preambuly pridaj (ak tam ešte nemáš):

```tex
\usepackage{tikz}
```

2. Do textu vlož:

```tex
\input{diagrams/out/example-class.tex}
```

