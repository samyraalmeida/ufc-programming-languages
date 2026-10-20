# Desenho de árvores (CTM, seção 3.4.7, Figura 3.18): cálculo das coordenadas.
#
# Árvore: :leaf | %{key: k, val: v, left: árvore, right: árvore}
# Resultado: a mesma árvore, com os campos :x e :y em cada nó.
#
# Variáveis de fluxo de dados: o programa em Oz as usa para
#   1) os campos x e y, criados não ligados por AddXY e ligados depois;
#   2) os parâmetros de saída ?RootX e ?RightLim;
#   3) nos casos de um só filho, a ligação X=RootX feita antes da chamada
#      recursiva, quando RootX ainda não tem valor.
# Elixir não as possui. Como o programa é sequencial e cada variável é ligada
# uma única vez, basta trocar as saídas por valores de retorno: depth_first/3
# devolve {árvore_com_xy, root_x, right_lim}, e o nó só é construído depois de
# calculados os filhos, quando x e y já são conhecidos. Assim AddXY é desnecessário.
defmodule TreeDrawing do
  @scale 30

  def draw(:leaf), do: :leaf

  def draw(tree) do
    {drawn, _root_x, _right_lim} = depth_first(tree, 1, @scale)
    drawn
  end

  # Lista {key, x, y} dos nós em ordem de profundidade, para conferência.
  def coordinates(:leaf), do: []

  def coordinates(%{key: key, x: x, y: y, left: left, right: right}) do
    [{key, x, y} | coordinates(left) ++ coordinates(right)]
  end

  defp depth_first(%{left: :leaf, right: :leaf} = tree, level, left_lim) do
    {place(tree, left_lim, level), left_lim, left_lim}
  end

  defp depth_first(%{left: left, right: :leaf} = tree, level, left_lim) do
    {left_drawn, root_x, right_lim} = depth_first(left, level + 1, left_lim)
    {place(%{tree | left: left_drawn}, root_x, level), root_x, right_lim}
  end

  defp depth_first(%{left: :leaf, right: right} = tree, level, left_lim) do
    {right_drawn, root_x, right_lim} = depth_first(right, level + 1, left_lim)
    {place(%{tree | right: right_drawn}, root_x, level), root_x, right_lim}
  end

  defp depth_first(%{left: left, right: right} = tree, level, left_lim) do
    {left_drawn, l_root_x, l_right_lim} = depth_first(left, level + 1, left_lim)
    {right_drawn, r_root_x, right_lim} = depth_first(right, level + 1, l_right_lim + @scale)
    root_x = div(l_root_x + r_root_x, 2)
    {place(%{tree | left: left_drawn, right: right_drawn}, root_x, level), root_x, right_lim}
  end

  defp place(tree, x, level), do: Map.merge(tree, %{x: x, y: @scale * level})
end

# Árvore de exemplo da Figura 3.17
tree = fn key, val, left, right -> %{key: key, val: val, left: left, right: right} end
childless = fn key, val -> tree.(key, val, :leaf, :leaf) end

example =
  tree.(:a, 111,
    tree.(:b, 55,
      tree.(:x, 100, childless.(:z, 56), childless.(:w, 23)),
      tree.(:y, 105, :leaf, childless.(:r, 77))),
    tree.(:c, 123,
      tree.(:d, 119,
        childless.(:g, 44),
        tree.(:h, 50, childless.(:i, 5), childless.(:j, 6))),
      childless.(:e, 133)))

example
|> TreeDrawing.draw()
|> TreeDrawing.coordinates()
|> Enum.each(fn {key, x, y} -> IO.puts("#{key}: (#{x}, #{y})") end)