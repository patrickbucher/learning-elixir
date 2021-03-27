defmodule IncomeTax do
  def calculate(salary) do
    cond do
      salary <= 2000 -> 0
      salary <= 3000 -> salary * 0.05
      salary <= 10000 -> salary * 0.1
      true -> salary * 0.15
    end
  end
end

IO.puts "1000: #{IncomeTax.calculate(1000)}"
IO.puts "2500: #{IncomeTax.calculate(2500)}"
IO.puts "5000: #{IncomeTax.calculate(5000)}"
IO.puts "15000: #{IncomeTax.calculate(15000)}"
