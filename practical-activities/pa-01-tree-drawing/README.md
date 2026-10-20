# Atividade Prática 1 - Desenho de Árvores em Elixir

**Universidade Federal do Ceará**
**Departamento de Computação**
**Disciplina:** Linguagens de Programação CK0115)
**Trabalho Prático 01**

**Aluna:** Samyra Vitória Lima de Almeida
**Matrícula:** 521240

---

## O que é

Implementação em **Elixir** do programa da seção 3.4.7 (*Drawing trees*) do livro
*Concepts, Techniques, and Models of Computer Programming*, de Peter Van Roy e Seif Haridi.

O programa recebe uma árvore binária e calcula as coordenadas `(x, y)` de cada nó,
seguindo o algoritmo da Figura 3.18 do livro, originalmente escrito em Oz.

## Requisitos do trabalho

Usando a linguagem Elixir, implementar o programa da seção 3.4.7 (desenho de árvores).

Observações importantes:

1. No programa da seção 3.4.7, não é essencial desenhar a árvore em formato gráfico
   ou textual. É suficiente o cálculo das coordenadas dos nós.
2. Avaliar se o programa em Oz necessita de variáveis não ligadas (*dataflow variables*).
   Nesse caso, se a linguagem escolhida não suportar variáveis de dataflow, pensar em uma
   solução para contornar isso e explicá-la no próprio código.

## Como os requisitos foram atendidos

**1. Cálculo das coordenadas.** Assim como no livro, o programa não desenha a árvore.
A função `TreeDrawing.draw/1` devolve a mesma árvore com os campos `x` e `y` preenchidos
em cada nó.

**2. Variáveis de fluxo de dados.** O programa em Oz as usa em três lugares:

- nos campos `x` e `y` de cada nó, criados não ligados por `AddXY` e ligados depois;
- nos parâmetros de saída `?RootX` e `?RightLim` de `DepthFirst`;
- nos casos de um só filho, na ligação `X=RootX`, feita antes da chamada recursiva,
  quando `RootX` ainda não tem valor.

Elixir não possui variáveis de fluxo de dados. Neste caso elas não são essenciais, pois o
programa é sequencial e cada variável é ligada uma única vez. A solução adotada foi:

- `depth_first/3` **retorna** `{árvore_com_xy, root_x, right_lim}` em vez de usar
  parâmetros de saída;
- cada nó só é construído **depois** que os filhos foram calculados, quando `x` e `y` já são
  conhecidos. Com isso, `AddXY` deixa de ser necessário, e `Map.merge` faz o papel do
  `Adjoin` do Oz.

A explicação completa está no comentário no topo de `tree_drawing.exs`.

## Algoritmo

Entrada: `:leaf` ou `%{key: k, val: v, left: árvore, right: árvore}`.
Constantes: `Scale = 30`, `Level = 1` e `LeftLim = Scale` na raiz.

| Caso | Coordenada x do nó |
|---|---|
| Sem filhos | `LeftLim` |
| Um filho | mesmo `x` do filho (diretamente acima dele) |
| Dois filhos | média inteira (`div`) dos `x` dos filhos; a subárvore direita começa em `RightLim` da esquerda + `Scale` |

A coordenada vertical é `y = Scale * nível`, crescendo para baixo.

## Estrutura

| Arquivo | Conteúdo |
|---|---|
| `tree_drawing.exs` | módulo `TreeDrawing` (a implementação) e a demonstração com a árvore da Figura 3.17 |

Funções públicas do módulo `TreeDrawing`:

- `draw/1`: devolve a árvore com `x` e `y` em cada nó (`draw(:leaf)` devolve `:leaf`);
- `coordinates/1`: lista os nós como `{chave, x, y}`, na ordem da busca em profundidade.

## Como executar

Requer Elixir instalado (testado com a versão 1.14).

```bash
elixir tree_drawing.exs
```

A saída lista cada nó da árvore da Figura 3.17 no formato `chave: (x, y)`:

```
a: (121, 30)
b: (67, 60)
x: (45, 90)
...
```

Uso em outro código:

```elixir
tree = %{key: :a, val: 1,
         left:  %{key: :b, val: 2, left: :leaf, right: :leaf},
         right: %{key: :c, val: 3, left: :leaf, right: :leaf}}

tree |> TreeDrawing.draw() |> TreeDrawing.coordinates()
# [{:a, 45, 30}, {:b, 30, 60}, {:c, 60, 60}]
```

## Resultado para a árvore da Figura 3.17

| Nó | (x, y) | Nó | (x, y) |
|---|---|---|---|
| a | (121, 30) | c | (176, 60) |
| b | (67, 60) | d | (142, 90) |
| x | (45, 90) | g | (120, 120) |
| z | (30, 120) | h | (165, 120) |
| w | (60, 120) | i | (150, 150) |
| y | (90, 90) | j | (180, 150) |
| r | (90, 120) | e | (210, 90) |

## Referência

VAN ROY, Peter; HARIDI, Seif. *Concepts, Techniques, and Models of Computer Programming*.
MIT Press, 2004. Seção 3.4.7, Figuras 3.16 a 3.19.