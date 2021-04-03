defmodule SortAscDesc do

  def ascending([]), do: []
  def ascending([a]), do: [a]
  def ascending(list) do
    leq = fn(l, r) -> l <= r end
    half_size = div(Enum.count(list), 2)
    {list_a, list_b} = Enum.split(list, half_size)
    merge(ascending(list_a), ascending(list_b), leq, [])
  end

  def descending([]), do: []
  def descending([a]), do: [a]
  def descending(list) do
    geq = fn(l, r) -> l >= r end
    half_size = div(Enum.count(list), 2)
    {list_a, list_b} = Enum.split(list, half_size)
    merge(descending(list_a), descending(list_b), geq, [])
  end

  defp merge([], [], _before, acc), do: acc
  defp merge(list_a, [], _before, []), do: list_a
  defp merge([], list_b, _before, []), do: list_b
  defp merge(list_a, [], _before, acc), do: acc ++ list_a
  defp merge([], list_b, _before, acc), do: acc ++ list_b
  defp merge(l_a = [h_a | t_a], l_b = [h_b | t_b], before, acc) do
    if before.(h_a, h_b) do
      merge(t_a, l_b, before, acc ++ [h_a])
    else
      merge(l_a, t_b, before, acc ++ [h_b])
    end
  end

end
