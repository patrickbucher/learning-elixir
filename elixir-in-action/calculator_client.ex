defmodule CalculatorClient do
  def run(calc) do
    send(calc, {:add, self(), 3, 1})
    send(calc, {:sub, self(), 3, 1})
    receive do
      {:ok, x} -> IO.puts(x)
    end
    receive do
      {:ok, x} -> IO.puts(x)
    end
  end
end
