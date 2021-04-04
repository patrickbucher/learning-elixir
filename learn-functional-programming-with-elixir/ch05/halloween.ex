defmodule Halloween do
  def give_candy(kids) do
    ~w(chocolate jelly mint)
      |> Stream.cycle
      |> Enum.zip(kids)
  end
end
