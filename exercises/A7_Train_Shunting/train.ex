defmodule Train do
  def take(train, n) do Enum.take(train, n) end
  def drop(train, n) do Enum.drop(train, n) end
  def append(train1, train2) do train1 ++ train2 end
  def member([], _) do false end
  def member([wagon|_], wagon) do true end
  def member([_|tail], wagon) do member(tail, wagon) end
  def position(train, wagon) do
    Enum.find_index(train, fn x -> x == wagon end) + 1
  end
  def splitleft([], _) do [] end
  def splitleft([wagon|_], wagon) do [] end
  def splitleft([head|tail], wagon) do [head|splitleft(tail, wagon)] end
  def splitright([], _) do [] end
  def splitright([wagon|tail], wagon) do tail end
  def splitright([_head|tail], wagon) do splitright(tail, wagon) end
  def split(train, wagon) do
    {splitleft(train, wagon), splitright(train, wagon)}
  end

  def main_left(_, 0) do [] end
  def main_left([head|tail], amount) do [head|main_left(tail, amount-1)] end

  def main_right(taken, 0) do taken end
  def main_right([_|tail], amount) do main_right(tail, amount-1) end

  def main_split(train, 0) do {0, train, []} end
  def main_split(train, take) do
    amount = length(train) - take
    if amount <= 0 do
      {-amount, [], train}
    else
      {amount, main_left(train, amount), main_right(train, amount)}
    end
  end
end
