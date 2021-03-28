p. 80

# Write two recursive functions...

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

# In the section...

    defmodule GeneralStore do

      def fantasy_data do
        [
          %{title: "Longsword", price: 50, magic: false},
          %{title: "Healing Potion", price: 60, magic: true},
          %{title: "Rope", price: 10, magic: false},
          %{title: "Dragon's Spear", price: 100, magic: true},
        ]
      end

      def filter_items([], magic: _magic?), do: []
      def filter_items([head | tail], magic: magic?) do
        if head.magic == magic? do
          [head | filter_items(tail, magic: magic?)]
        else
          filter_items(tail, magic: magic?)
        end
      end
      
    end

# We've created...

    defmodule SortAscDesc do

      def ascending([]), do: []
      def ascending([a]), do: [a]
      def ascending(list) do
        leq = fn(l, r) -> l <= r end
        half_size = div(Enum.count(list), 2)
        {list_a, list_b} = Enum.split(list, half_size)
        merge(ascending(list_a), ascending(list_b), leq)
      end

      def descending([]), do: []
      def descending([a]), do: [a]
      def descending(list) do
        geq = fn(l, r) -> l >= r end
        half_size = div(Enum.count(list), 2)
        {list_a, list_b} = Enum.split(list, half_size)
        merge(descending(list_a), descending(list_b), geq)
      end

      defp merge([], list_b, _before), do: list_b
      defp merge(list_a, [], _before), do: list_a
      defp merge(l_a = [h_a | t_a], l_b = [h_b | t_b], before) do
        if before.(h_a, h_b) do
          [h_a | merge(t_a, l_b, before)]
        else
          [h_b | merge(l_a, t_b, before)]
        end
      end

    end

# We've written...

    defmodule Sum do
      def up_to(n), do: sum(n, 0)

      defp sum(0, acc), do: acc
      defp sum(n, acc), do: sum(n - 1, acc + n)
    end

    defmodule Math do
      def sum([]), do: 0
      def sum(list), do: sum_acc(list, 0)

      defp sum_acc([], acc), do: acc
      defp sum_acc([head | tail], acc), do: sum_acc(tail, head + acc)

    end

# In the s ection...

    defmodule BreadthNavigator do

      @max_breadth 3

      def navigate(dir) do
        expanded_dir = Path.expand(dir)
        go_through([expanded_dir])
      end

      defp go_through([]), do: nil
      defp go_through([content | rest]) do
        print_and_navigate(content, File.dir?(content))
        go_through(rest)
      end

      defp print_and_navigate(file, false), do: IO.puts "#{file}"
      defp print_and_navigate(dir, true) do
        IO.puts dir
        children_dirs = File.ls!(dir)
        go_through(expand_dirs(children_dirs, dir, 0, []))
      end

      defp expand_dirs([], _relative_to, _breadth, acc), do: acc
      defp expand_dirs([dir | dirs], relative_to, breadth, acc) when breadth < @max_breadth do
        expanded_dir = Path.expand(dir, relative_to)
        expand_dirs(dirs, relative_to, breadth + 1, [expanded_dir | acc])
      end
      defp expand_dirs(_dirs, _relative_to, _breadth, acc), do: acc

    end
