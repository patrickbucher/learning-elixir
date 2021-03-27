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
