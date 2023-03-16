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

    vict = Integer.mod((you - 1), 3)
    cond do
      vict == opp -> 6 + you + 1
      you == opp -> 3 + you + 1
      true -> you + 1
    end
  end
end
