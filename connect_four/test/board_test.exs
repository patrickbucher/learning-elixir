defmodule BoardTest do
  use ExUnit.Case

  test "empty board" do
    board = [
      [:e, :e, :e, :e, :e, :e, :e],
      [:e, :e, :e, :e, :e, :e, :e],
      [:e, :e, :e, :e, :e, :e, :e],
      [:e, :e, :e, :e, :e, :e, :e],
      [:e, :e, :e, :e, :e, :e, :e],
      [:e, :e, :e, :e, :e, :e, :e]
    ]

    assert Board.empty() == board
  end

  test "get rows" do
    board = [
      [:a, :a, :a, :a, :a, :a, :a],
      [:e, :e, :e, :e, :e, :e, :e],
      [:c, :c, :c, :c, :c, :c, :c],
      [:e, :e, :e, :e, :e, :e, :e],
      [:e, :e, :e, :e, :e, :e, :e],
      [:f, :f, :f, :f, :f, :f, :f]
    ]

    assert Board.row(board, 0) == [:a, :a, :a, :a, :a, :a, :a]
    assert Board.row(board, 2) == [:c, :c, :c, :c, :c, :c, :c]
    assert Board.row(board, 5) == [:f, :f, :f, :f, :f, :f, :f]
  end

  test "get cols" do
    board = [
      [:a, :e, :e, :d, :e, :e, :g],
      [:a, :e, :e, :d, :e, :e, :g],
      [:a, :e, :e, :d, :e, :e, :g],
      [:a, :e, :e, :d, :e, :e, :g],
      [:a, :e, :e, :d, :e, :e, :g],
      [:a, :e, :e, :d, :e, :e, :g]
    ]

    assert Board.col(board, 0) == [:a, :a, :a, :a, :a, :a]
    assert Board.col(board, 3) == [:d, :d, :d, :d, :d, :d]
    assert Board.col(board, 6) == [:g, :g, :g, :g, :g, :g]
  end

  test "get diags" do
    board = [
      [:_, :u, :_, :_, :_, :y, :_],
      [:_, :_, :v, :_, :x, :_, :_],
      [:_, :_, :_, :w, :_, :_, :_],
      [:_, :_, :v, :_, :x, :_, :_],
      [:_, :u, :_, :_, :_, :y, :_],
      [:t, :_, :_, :_, :_, :_, :z]
    ]

    assert Board.diag_up(board, 2, 3) == [:t, :u, :v, :w, :x, :y]
    assert Board.diag_dn(board, 2, 3) == [:u, :v, :w, :x, :y, :z]
  end
end
