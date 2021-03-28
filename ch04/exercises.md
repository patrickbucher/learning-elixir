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
