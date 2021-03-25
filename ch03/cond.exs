{weight_kg, _} = Integer.parse(IO.gets("Weight [kg]: "))
{height_cm, _} = Integer.parse(IO.gets("Height [cm]: "))

height_m = height_cm / 100
height_square = height_m * height_m
bmi = weight_kg / height_square

result = cond do
  bmi < 20 -> "BMI #{bmi} is underweight"
  bmi <= 25 -> "BMI #{bmi} is good"
  bmi > 25 -> "BMI #{bmi} is overweight"
end

IO.puts result
