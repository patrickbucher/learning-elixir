defmodule RPG do
  def total_points(skills) do
    %{strength: strength} = skills
    %{dexterty: dexterty} = skills
    %{intelligence: intelligence} = skills
    strength * 2 + (dexterty + intelligence) * 3
  end
end

skills = %{strength: 13, dexterty: 11, intelligence: 7}
points = RPG.total_points(skills)
IO.puts("total points: #{points}")
