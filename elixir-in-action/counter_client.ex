defmodule CounterClient do
  def run(counter) do
    Enum.each(1..99, fn _ -> send(counter, :inc) end)
    Enum.each(1..98, fn _ -> send(counter, :dec) end)
    send(counter, {:val, self()})
    receive do
      x -> IO.puts(x)
    end
  end
end
