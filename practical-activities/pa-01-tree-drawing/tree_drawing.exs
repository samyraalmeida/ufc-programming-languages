# Desenho de árvores (CTM, seção 3.4.7, Figura 3.18): cálculo das coordenadas.
#
# Árvore: :leaf | %{key: k, val: v, left: árvore, right: árvore}
# Resultado: a mesma árvore, com os campos :x e :y em cada nó.
#
# Variáveis de fluxo de dados: o programa em Oz as usa para
#   1) os campos x e y, criados não ligados por AddXY e ligados depois;
#   2) os parâmetros de saída ?RootX e ?RightLim.
# Elixir não as possui. Como o programa é sequencial e cada variável é ligada
# uma única vez, basta trocar as saídas por valores de retorno: depth_first/3
# devolve {árvore_com_xy, root_x, right_lim}, e o nó só é construído depois de
# calculados os filhos, quando x e y já são conhecidos. Assim AddXY é desnecessário.
defmodule TreeDrawing do
  @scale 30

  def draw(tree) do
    {drawn, _root_x, _right_lim} = depth_first(tree, 1, @scale)
    drawn
  end

  defp depth_first(%{left: :leaf, right: :leaf} = tree, level, left_lim) do
    {place(tree, left_lim, level), left_lim, left_lim}
  end

  defp depth_first(%{left: left, right: :leaf} = tree, level, left_lim) do
    {left, root_x, right_lim} = depth_first(left, level + 1, left_lim)
    {place(%{tree | left: left}, root_x, level), root_x, right_lim}
  end

  defp depth_first(%{left: :leaf, right: right} = tree, level, left_lim) do
    {right, root_x, right_lim} = depth_first(right, level + 1, left_lim)
    {place(%{tree | right: right}, root_x, level), root_x, right_lim}
  end

  defp depth_first(%{left: left, right: right} = tree, level, left_lim) do
    {left, l_root_x, l_right_lim} = depth_first(left, level + 1, left_lim)
    {right, r_root_x, right_lim} = depth_first(right, level + 1, l_right_lim + @scale)
    root_x = div(l_root_x + r_root_x, 2)
    {place(%{tree | left: left, right: right}, root_x, level), root_x, right_lim}
  end

  defp place(tree, x, level), do: Map.merge(tree, %{x: x, y: @scale * level})
end

# Árvore de exemplo da Figura 3.17
node = fn key, val, left, right -> %{key: key, val: val, left: left, right: right} end
leaf = fn key, val -> node.(key, val, :leaf, :leaf) end

example =
  node.(:a, 111,
    node.(:b, 55,
      node.(:x, 100, leaf.(:z, 56), leaf.(:w, 23)),
      node.(:y, 105, :leaf, leaf.(:r, 77))),
    node.(:c, 123,
      node.(:d, 119,
        leaf.(:g, 44),
        node.(:h, 50, leaf.(:i, 5), leaf.(:j, 6))),
      leaf.(:e, 133)))

IO.inspect(TreeDrawing.draw(example), limit: :infinity)