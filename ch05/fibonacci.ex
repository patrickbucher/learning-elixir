defmodule Fibonacci do
  def of(n) do
    Stream.unfold({0, 0}, fn
      {0, 0} -> {1, {0, 1}}
      {i, j} -> {i + j, {j, i + j}}
    end)
    |> Enum.take(n)
    |> Enum.to_list()
  end
end
