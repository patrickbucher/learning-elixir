p. 31

# Create an expression...

  > 10 * 0.1 + 3 * 2 + 1 * 15
  22.0

# Bob has traveled...

  > distance_km = 200
  > travel_hours = 4
  > IO.puts "#{distance_km} km in ${travel_hours} hours is #{distance_km/travel_hours} km/h"
  200 km in 4 hours is 50.0 km/h

# Build an anonymous... 

  tax_rate = 0.12

  apply_tax = fn price ->
    tax = price * tax_rate
    new_price = price + tax
    IO.puts "Price: #{new_price} - Tax: #{tax}"
  end

  Enum.each [12.5, 30.99, 250.49, 18.80], apply_tax

# Create a module...

  defmodule MatchstickFactory do
    def boxes(matchsticks) do
      big = div(matchsticks, 50)
      matchsticks = rem(matchsticks, 50)
      medium = div(matchsticks, 20)
      matchsticks = rem(matchsticks, 20)
      small = div(matchsticks, 5)
      matchsticks = rem(matchsticks, 5)
      %{big: big, medium: medium, small: small, remaining_matchsticks: matchsticks}
    end
  end
