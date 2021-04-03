defmodule Quicksort do
  def asc([]), do: []
  def asc([n]), do: [n]
  def asc([pivot | tail]) do
    {less, more} = Enum.split_with(tail, fn x -> x < pivot end)
    asc(less) ++ [pivot] ++ asc(more)
  end
end
