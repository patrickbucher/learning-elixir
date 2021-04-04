defmodule Factorial do
  def of(0), do: 1
  def of(n) when n > 0 do
    Stream.iterate(1, fn prev -> prev + 1 end)
      |> Enum.take(n)
      |> Enum.reduce(&(&1 * &2))
  end
end
