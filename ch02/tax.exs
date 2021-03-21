tax_rate = 0.12

apply_tax = fn price ->
  tax = price * tax_rate
  new_price = price + tax
  IO.puts "Price: #{new_price} - Tax: #{tax}"
end

Enum.each [12.5, 30.99, 250.49, 18.80], apply_tax
