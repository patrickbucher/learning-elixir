# Elixir

Run Elixir's interactive shell:

  $ iex

Create a _"Hello, World!"_ program in the interactive shell:

  iex> IO.puts "Hello, World!"
  Hello, World!
  :ok

There are two extensions for Elixir files:

1. `.ex` for files to be compiled
2. `.exs` for script files to be executed directly

Create a _"Hello, World!"_ program in a file called `hello_world.exs`:

  IO.puts "Hello, World!"

Run the program using Elixir:

  $ elixir hello_world.exs
  Hello, World!

## Thinking Functionally

Elixir uses immutable data structures. The original `list` object is never
modified, but new list objects are returned.

  > list = [1, 2, 3, 4]
  [1, 2, 3, 4]
  > List.delete_at(list, -1)
  [1, 2, 3]
  > list ++ [1]
  [1, 2, 3, 1]
  > list
  [1, 2, 3, 4]

`delete_at` is not a method of the list itself, but a function of the
`List` module, which can be applied to lists, and that returns new lists
instead of modifying an underlying list.

A pure function only depends on its parameters:

  > twice = fn (n) -> n * 2 end
  > twice.(3)
  6

Instead of maintaining internal state with classes, modules provide
functions that operate on data without manipulating it, but returning
the modified versions of that data (`set.exs`):

  defmodule MySet do
    defstruct items: []
    def push(set = %{items: items}, item) do
      if Enum.member?(items, item) do
        set
      else
        %{set | items: items ++ [item]}
      end
    end
  end

This module can be used as follows:

  $ iex set.exs
  > set = %MySet{}
  > set = MySet.push(set, "apple")
  > new_set = %MySet{}
  > new_set = MySet.push(new_set, "pie")
  > IO.inspect MySet.push(set, "apple")
  %MySet{items: ["apple"]}
  > IO.inspect MySet.push(new_set, "apple")
  %MySet{items: ["pie", "apple"]}

Functions can be used as arguments. Here, the `upcase` function of the
`String` module is applied to a list of strings:

  > Enum.map(["dogs", "cats", "mice"], &String.upcase/1)
  ["DOGS", "CATS", "MICE"]

The result of a function call can be used as the parameter to a subsequent
function call using the pipe operator `|>`. Instead of using nested function
calls:

  > String.split(String.downcase(String.trim("  THIS IS A TEST  ")))
  ["this", "is", "a", "test"]

The pipe operator can be used to chain the function calls together:

  > "  THIS IS A TEST  " |> String.trim |> String.downcase |> String.split
  ["this", "is", "a", "test"]

Instead of explicitly stating the control flow, this recursive function
only defines the steps to transform the data (`stringlist.exs`):

  defmodule StringList do
    def upcase([]), do: []
    def upcase([first | rest]), do: [String.upcase(first) | upcase(rest)]
  end

Which can be used as follows:

  $ iex stringlist.exs
  > StringList.upcase(["foo", "bar", "baz", "bum"])
  ["FOO", "BAR", "BAZ", "BUM"]

Higher-order functions simplify commonly used operations such as
processing lists of items:

  > list = ["foo", "bar", "baz", "bum"]
  > Enum.map(list, &String.upcase/1)
  ["FOO", "BAR", "BAZ", "BUM"]
