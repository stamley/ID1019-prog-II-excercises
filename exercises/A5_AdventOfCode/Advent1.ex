defmodule Advent do
  def fattest(input) do Enum.max(calories({:string, input})) end
  def fattest3(input) do threeMax(calories({:string, input})) end

  def calories({:string, input}) do calories(String.split(input, "\n\n")) end
  def calories([]) do [] end
  def calories([head|tail]) do
    items = String.split(head, "\n")
    [reduce(items)|calories(tail)]
  end
  def reduce([tail]) do String.to_integer(tail) end
  def reduce([head|tail]) do String.to_integer(head) + reduce(tail) end

  def threeMax(list) do
    first = Enum.max(list)
    list = new(list, first)
    second = Enum.max(list)
    list = new(list, second)
    third = Enum.max(list)
    first + second + third
  end
  def new([], _) do [] end
  def new([head|tail], avoid) when head == avoid do new(tail, avoid) end
  def new([head|tail], avoid) do [head|new(tail, avoid)] end
end
