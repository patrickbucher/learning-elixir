defmodule TaxCalc do

  import IncomeTax, only: [calculate: 1]

  def run_calc() do
    input = IO.gets("Your salary: ")
    case Integer.parse(input) do
      :error -> IO.puts("that's not a number")
      {salary, _} -> IO.puts("Your tax: #{IncomeTax.calculate(salary)}")
    end
  end

end
