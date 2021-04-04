user_input = IO.gets "What's your IQ? "
output = case Integer.parse(user_input) do
  :error -> "Malformed IQ: #{user_input}"
  {iq, _} -> "Your IQ is #{iq}"
end
IO.puts output
