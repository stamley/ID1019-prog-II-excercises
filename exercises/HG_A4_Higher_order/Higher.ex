defmodule Higher do
  # Basis for higher order functions.
  # Based on type, do one function or another.
  def double_five_animal([], _) do [] end
  def double_five_animal([h|t], type) do
    case type do
      :double -> [h * 2|double_five_animal(t, type)]
      :five ->
        [5 + h|double_five_animal(t, type)]
      :animal ->
        if h == :dog do
          [:fido|double_five_animal(t, type)]
        else
          [h|double_five_animal(t, type)]
        end
    end
  end
  def double(list) do double_five_animal(list, :double) end
  def five(list) do double_five_animal(list, :five) end
  def animal(list) do double_five_animal(list, :animal) end

  # Test functions for apply_to_all
  def f() do fn(x) -> x * 2 end end
  def g() do fn(x) -> x + 5 end end
  def h() do fn(x) -> if x == :dog, do: :fido, else: x end end

  # Receive a function which is applied on each element in a list
  def apply_to_all([], _) do [] end
  def apply_to_all([h|t], func) do
    [func.(h)|apply_to_all(t, func)]
  end

  # def sum([]) do 0 end
  # def sum([h|t]) do h+sum(t) end

  # right-to-left
  # Applies the function on the way "back up"
  def fold_right([], base, _) do base end
  def fold_right([h|t], base, f) do
    f.(h, fold_right(t, base, f))
  end
  def sum(list) do fold_right(list, 0, fn(x, y) -> x + y end) end
  def prod(list) do fold_right(list, 1, fn(x, y) -> x * y end) end

  # In fold left, the base is accumulative, it will be the resulting
  # sum, product or whatever the function put in is.
  # left-to-right
  # Applies the function on the "way down"
  def fold_left([], base, _) do base end
  def fold_left([h|t], base, f) do
    fold_left(t, f.(h, base), f)
  end

  def odd([]) do [] end
  def odd([h|t]) do
    if rem(h, 2) == 1 do
      [h|odd(t)]
    else
      odd(t)
    end
  end

  # Based on condition, filter out list, eg odd even or greater
  # than five
  def filter([], _) do [] end
  def filter([h|t], condition) do
    if condition.(h) do
      [h|filter(t, condition)]
    else
      filter(t, condition)
    end
  end

  def even(list) do filter(list, fn(x) -> rem(x, 2) == 0 end) end
  def greater_than_five(list) do filter(list, fn(x) -> x > 5 end) end
end
