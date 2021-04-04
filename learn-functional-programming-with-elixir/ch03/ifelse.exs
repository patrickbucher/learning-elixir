a = 13
b = 3

bigger = if a > b do
  a
else
  b
end

smaller = unless a > b do
  a
else
  b
end

IO.puts "bigger: #{bigger}"
IO.puts "smaller: #{smaller}"
