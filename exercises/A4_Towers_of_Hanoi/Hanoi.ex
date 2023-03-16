defmodule Hanoi do
  def hanoi(1, {:move, from, to}) do IO.puts("#{from} -> #{to}") end
  def hanoi(n, {:move, from, to}) do
    other = 6 - (from + to)
    hanoi(n - 1, {:move, from, other})
    IO.puts("#{from} -> #{to}")
    hanoi(n - 1, {:move, other, to})
  end
end
