defmodule CalculatorServer do
  def start do
    spawn(&loop/0)
  end

  defp loop do
    receive do
      {:add, caller, a, b} -> send(caller, {:ok, a + b})
      {:sub, caller, a, b} -> send(caller, {:ok, a - b})
      {:mul, caller, a, b} -> send(caller, {:ok, a * b})
      {:div, caller, a, b} -> send(caller, {:ok, a / b})
    end
    loop()
  end
end
