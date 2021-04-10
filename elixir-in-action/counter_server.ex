defmodule CounterServer do
  def start do
    spawn(fn -> loop(0) end)
  end

  def loop(state) do
    new_state =
      receive do
        :inc -> state + 1
        :dec -> state - 1
        {:val, caller} ->
          send(caller, state)
          state
      end
    loop(new_state)
  end
end
