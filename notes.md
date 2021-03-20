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
