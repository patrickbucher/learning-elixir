defmodule Math do
  def sum([]), do: 0
  def sum(list), do: sum_acc(list, 0)

  defp sum_acc([], acc), do: acc
  defp sum_acc([head | tail], acc), do: sum_acc(tail, head + acc)

end
