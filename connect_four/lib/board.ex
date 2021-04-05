defmodule Board do
  @n_cols 7
  @n_rows 6

  def empty do
    row =
      for _ <- 1..@n_cols, into: [] do
        :e
      end

    for _ <- 1..@n_rows, into: [] do
      row
    end
  end
end
