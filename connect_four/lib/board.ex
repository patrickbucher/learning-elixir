defmodule Board do
  @n_cols 7
  @n_rows 6
  @empty :_

  def empty do
    row =
      for _ <- 0..(@n_cols - 1), into: [] do
        @empty
      end

    for _ <- 0..(@n_rows - 1), into: [] do
      row
    end
  end

  def row(board, r) when r >= 0 and r < @n_rows do
    Enum.at(board, r)
  end

  def col(board, c) when c >= 0 and c < @n_cols do
    for r <- 0..(@n_rows - 1), into: [] do
      board |> Enum.at(r) |> Enum.at(c)
    end
  end

  def diag_up(board, r, c) when r >= 0 and r < @n_rows and c >= 0 and c < @n_cols do
    down = (r + 1)..(@n_rows - 1)
    left = (c - 1)..0

    lower =
      Enum.zip(down, left)
      |> Enum.filter(fn {y, x} -> y < @n_rows && x >= 0 end)
      |> Enum.reverse()

    up = (r - 1)..0
    right = (c + 1)..(@n_cols - 1)

    higher =
      Enum.zip(up, right)
      |> Enum.filter(fn {y, x} -> y >= 0 && x < @n_cols end)

    indices = lower ++ [{r, c}] ++ higher
    Enum.map(indices, pick(board))
  end

  def diag_dn(board, r, c) when r >= 0 and r < @n_rows and c >= 0 and c < @n_cols do
    down = (r + 1)..(@n_rows - 1)
    right = (c + 1)..(@n_cols - 1)

    lower =
      Enum.zip(down, right)
      |> Enum.filter(fn {y, x} -> y < @n_rows && x < @n_cols end)

    up = (r - 1)..0
    left = (c - 1)..0

    upper =
      Enum.zip(up, left)
      |> Enum.filter(fn {y, x} -> y >= 0 && x >= 0 end)
      |> Enum.reverse()

    indices = upper ++ [{r, c}] ++ lower
    Enum.map(indices, pick(board))
  end

  defp pick(board) do
    fn {y, x} -> board |> Enum.at(y) |> Enum.at(x) end
  end

  def set(board, slot, token) do
    c = col(board, slot)
    if @empty not in c do
      {:error, :no_empty_slot}
    else
      x = Enum.find(c, @n_rows, fn e -> e != @empty end) - 1
      r = row(board, x)
      r = List.replace_at(r, slot, token)
      {:ok, List.replace_at(board, x, r)}
    end
  end

end
