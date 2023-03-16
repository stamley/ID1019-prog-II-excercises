defmodule HigherTests do
  def double([]) do [] end
  def double([h|t]) do
    [h * 2 | double(t)]
  end

  def five([]) do [] end
  def five([h|t]) do
    [h + 5 | five(t)]
  end

  def animal([]) do [] end
  def animal([:dog|t]) do
    [:fido|animal(t)]
  end
  def animal([h|t]) do
    [h|animal(t)]
  end
end
