defmodule Sum do
  def up_to(n), do: sum(n, 0)

  defp sum(0, acc), do: acc
  defp sum(n, acc), do: sum(n - 1, acc + n)
end
