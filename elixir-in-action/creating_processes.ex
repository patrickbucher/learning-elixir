defmodule CreatingProcesses do
  def run() do
    run_query =
      fn query_def ->
        Process.sleep(2000)
        "#{query_def} result"
      end
    async_query =
      fn query_def ->
        spawn(fn -> IO.puts(run_query.(query_def)) end)
      end

    IO.puts("starting a single query")
    async_query.("query 1")

    IO.puts("starting five queries immediately")
    Enum.each(1..5, &async_query.("query #{&1}"))
  end
end
