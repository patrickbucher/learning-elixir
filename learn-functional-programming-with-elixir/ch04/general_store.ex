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
