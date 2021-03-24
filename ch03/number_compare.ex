defmodule NumberCompare do
  def greater(number, other_number) when number >= other_number, do: number
  def greater(_, other_number), do: other_number
end

number_compare.(3, 7)
number_compare.(7, 3)
