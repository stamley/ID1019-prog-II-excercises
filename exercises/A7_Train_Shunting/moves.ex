defmodule Moves do
  def single({:one, n}, {main, one, two}) do
    cond do
      n >= 0 ->
        one = Train.append(Train.drop(main, length(main) - n), one)
        main = Train.take(main, length(main) - n)
        {main, one, two}
      n < 0 ->
        main = Train.append(main, Train.drop(one, length(one) + n))
        one = Train.take(one, length(one) + n)
        {main, one, two}
    end
  end
  def single({:two, n}, {main, one, two}) do
    cond do
      n >= 0 ->
        two = Train.append(Train.drop(main, length(main) - n), two)
        main = Train.take(main, length(main) - n)
        {main, one, two}
      n < 0 ->
        main = Train.append(main, Train.drop(two, length(two) + n))
        two = Train.take(two, length(two) + n)
        {main, one, two}
    end
  end

  def single_main({:one, n}, {main, one, two}) do
    cond do
      n >= 0 ->
        {_, main, new} = Train.main_split(main, n)
        {main, new ++ one, two}
      n < 0 ->
        {_, new, one} = Train.main_split(one, length(one) + n)
        {main ++ new, one, two}
    end
  end
  def single_main({:two, n}, {main, one, two}) do
    cond do
      n >= 0 ->
        {_, main, new} = Train.main_split(main, n)
        {main, one, new ++ two}
      n < 0 ->
        {_, new, two} = Train.main_split(two, length(two) + n)
        {main ++ new, one, two}
    end
  end

  def sequence([], trains) do trains end
  def sequence([move|tail], trains) do
    [trains|sequence(tail, single(move, trains))]
  end






  # Return train with wagon from "from" to "to"

  #{one, main} = {to(one, main, n), from(main, n)}

  #{main, one} = {to(main, one, -n), from(one, -n)}


  #def to(to, from, n) do
  #  Train.append(to, Train.drop(from, length(from) - n))
  #end
  # Return train without wagons
  #def from(from, n) do
  #  Train.take(from, length(from) - n)
  #end

end
