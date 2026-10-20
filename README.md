<div align="center">

# Linguagens de Programação (CK0115)

### Atividades práticas da disciplina CK0115 — UFC

[![Elixir](https://img.shields.io/badge/Elixir-1.14-6e4a7e?logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Universidade Federal do Ceará](https://img.shields.io/badge/UFC-Universidade%20Federal%20do%20Cear%C3%A1-blue)](https://www.ufc.br/)

Repositório de estudos e implementações desenvolvidos na disciplina de
**Linguagens de Programação**, do Departamento de Computação da
**Universidade Federal do Ceará**.

</div>

---

## Sobre

Aqui estão reunidas atividades práticas que exploram conceitos de linguagens de
programação por meio de implementações e experimentos. Cada atividade tem sua
própria pasta e README com contexto, instruções e detalhes da solução.

## Atividades

| Atividade | Descrição | Linguagem |
| --- | --- | --- |
| [PA 01 — Desenho de árvores](./practical-activities/pa-01-tree-drawing/) | Calcula as coordenadas dos nós de uma árvore binária, inspirado na seção 3.4.7 de *Concepts, Techniques, and Models of Computer Programming*. | Elixir |

## Comece por aqui

Para executar a atividade de desenho de árvores, instale o
[Elixir](https://elixir-lang.org/install.html) (a implementação foi testada
com a versão 1.14) e rode, na raiz do repositório:

```bash
elixir practical-activities/pa-01-tree-drawing/tree_drawing.exs
```

O programa calcula e imprime as coordenadas `(x, y)` de cada nó da árvore de
exemplo. Para conhecer a estrutura de entrada, o algoritmo e a saída completa,
consulte o [README da atividade](./practical-activities/pa-01-tree-drawing/README.md).

## Organização

```text
.
├── practical-activities/
│   └── pa-01-tree-drawing/
│       ├── README.md
│       └── tree_drawing.exs
└── README.md
```

## Referência principal

VAN ROY, Peter; HARIDI, Seif. *Concepts, Techniques, and Models of Computer
Programming*. MIT Press, 2004. Seção 3.4.7 — “Drawing Trees”.

---

<div align="center">
Feito como parte dos estudos em Linguagens de Programação · UFC
</div>
