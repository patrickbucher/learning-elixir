defmodule MyList do

  def max([]), do: nil
  def max([head | _tail = []]), do: head
  def max([head | tail]) do
    cond do
      head > max(tail) -> head
      true -> max(tail)
    end
  end

  def min([]), do: nil
  def min([head | _tail = []]), do: head
  def min([head | tail]) do
    cond do
      head < min(tail) -> head
      true -> min(tail)
    end
  end

end
