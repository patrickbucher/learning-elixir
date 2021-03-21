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
