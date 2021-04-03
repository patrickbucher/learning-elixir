p. 102

# In Chapter 4...

    defmodule EnchanterShop do
      def test_data do
        [
          %{title: "Longsword", price: 50, magic: false},
          %{title: "Healing Potion", price: 60, magic: true},
          %{title: "Rope", price: 10, magic: false},
          %{title: "Dragon's Spear", price: 100, magic: true},
        ]
      end

      @enchanter_name "Edwin"

      def enchant_for_sale(items) do
        Enum.map(items, &enchant/1)
      end

      defp enchant(item = %{magic: true}), do: item
      defp enchant(item) do
        %{
          title: "#{@enchanter_name}'s #{item.title}",
          price: item.price * 3,
          magic: true
        }
      end

    end

# In this chapter...

    defmodule ScrewsFactory do

      def run(pieces) do
        pieces
        |> Stream.chunk_every(50)
        |> Stream.flat_map(&add_thread/1)
        |> Stream.chunk_every(100)
        |> Stream.flat_map(&add_head/1)
        |> Stream.chunk_every(70)
        |> Stream.flat_map(&add_pack/1)
        |> Enum.each(&output/1)
      end

      defp add_thread(pieces) do
        Process.sleep(50)
        Enum.map(pieces, &(&1 <> "--"))
      end

      defp add_head(pieces) do
        Process.sleep(100)
        Enum.map(pieces, &("o" <> &1))
      end

      defp add_pack(pieces) do
        Process.sleep(70)
        Enum.map(pieces, &("|" <> &1 <> "|"))
      end

      defp output(screw) do
        IO.inspect(screw)
      end

    end
