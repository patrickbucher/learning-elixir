defmodule BoardTest do
  use ExUnit.Case

  test "empty board" do
    assert Board.empty() == [
             [:e, :e, :e, :e, :e, :e, :e],
             [:e, :e, :e, :e, :e, :e, :e],
             [:e, :e, :e, :e, :e, :e, :e],
             [:e, :e, :e, :e, :e, :e, :e],
             [:e, :e, :e, :e, :e, :e, :e],
             [:e, :e, :e, :e, :e, :e, :e]
           ]
  end
end
