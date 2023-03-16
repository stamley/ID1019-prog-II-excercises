defmodule Adv do
  def parse([]) do [] end
  def parse([head|tail]) do
    [game(String.split(head, " "))|parse(tail)]
  end
  def start(input) do
    Enum.sum(parse(String.split(input, "\n")))
  end
  def game([opp, you]) do
    opp = hd(String.to_charlist(opp)) - 65
    you = hd(String.to_charlist(you)) - 88

    # X == 0 -> Lose
    # Y == 1 -> Draw
    # Z == 2 -> Win

    # vict = Integer.mod((you - 1), 3)
    # lose = Integer.mod((you + 1), 3)
    IO.puts("you")
    IO.puts(you)

    cond do
      you == 0 ->
        IO.puts(Integer.mod((opp + 1), 3) + 1)
        Integer.mod((you + 1), 3) + 1
      you == 1 ->
        IO.puts(3 + opp + 1)
        3 + opp + 1
      you == 2 ->
        IO.puts(6 + Integer.mod((you - 1), 3) + 1)
        6 + Integer.mod((opp - 1), 3) + 1
    end
  end
end
