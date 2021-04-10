defmodule MessagePassing do
  def run() do
    worker = fn ->
      receive do
        {:add, a, b, pid} -> send(pid, {:ok, a + b})
        {:sub, a, b, pid} -> send(pid, {:ok, a - b})
        {:mul, a, b, pid} -> send(pid, {:ok, a * b})
        {:div, _, 0, pid} -> send(pid, {:err, :div_by_zero})
        {:div, a, b, pid} -> send(pid, {:div, a / b})
      after
        5000 -> IO.puts("unable to process message")
      end
    end
    consumer = fn ->
      receive do
        {:ok, x} -> IO.puts("result: #{x}")
        {:err, e} -> IO.puts("failed: #{e}")
      end
    end
    send(spawn(worker), {:add, 5, 3, spawn(consumer)})
    send(spawn(worker), {:sub, 5, 3, spawn(consumer)})
    Process.sleep(1000)
  end
end
