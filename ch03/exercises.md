p. 57

# In RPGs, ...

    defmodule RPG do
      def total_points(skills) do
        %{strength: strength} = skills
        %{dexterty: dexterty} = skills
        %{intelligence: intelligence} = skills
        strength * 2 + (dexterty + intelligence) * 3
      end
    end

    skills = %{strength: 13, dexterty: 11, intelligence: 7}
    points = RPG.total_points(skills)
    IO.puts("total points: #{points}")

# Create a function that returns Tic-Tac-Toe...

    defmodule TicTacToe do

      def winner(board) do
        cond do
          winner(board, :x) -> {:winner, :x}
          winner(board, :o) -> {:winner, :o}
          true -> {:no_winner}
        end
      end

      defp winner(board, p), do: won(board, p)

      # diagonal
      defp won({_, _, p, _, p, _, p, _, _}, p), do: true
      defp won({p, _, _, _, p, _, _, _, p}, p), do: true

      # rows
      defp won({p, p, p, _, _, _, _, _, _}, p), do: true
      defp won({_, _, _, p, p, p, _, _, _}, p), do: true
      defp won({_, _, _, _, _, _, p, p, p}, p), do: true

      # cols
      defp won({p, _, _, p, _, _, p, _, _}, p), do: true
      defp won({_, p, _, _, p, _, _, p, _}, p), do: true
      defp won({_, _, p, _, _, p, _, _, p}, p), do: true

      # mismatch
      defp won({_, _, _, _, _, _, _, _, _}, _), do: false

    end

    winner1 = TicTacToe.winner({
      :x, :o, :x,
      :o, :x, :o,
      :o, :o, :o,
    })
    IO.inspect winner1

    winner2 = TicTacToe.winner({
      :x, :o, :x,
      :o, :x, :o,
      :o, :x, :o,
    })
    IO.inspect winner2

    winner3 = TicTacToe.winner({
      :x, :o, :x,
      :o, :x, :o,
      :x, :x, :o,
    })
    IO.inspect winner3

# Create a function that calculates income tax...

# Create an Elixir scsript where users...
