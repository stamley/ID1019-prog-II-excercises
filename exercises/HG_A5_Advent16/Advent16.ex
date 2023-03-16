defmodule Advent16 do
  def graph(input) do graphify(String.split(input, "\n")) end
  def graphify(list) do
    for string <- list do
      string = String.split(string, " ")
      {:valve, string[1], {:flow, String.slice(string[4], 5, 2)}, {:links, links(string, length(string), 9)}}
    end
  end
  def links(string, length, index) when index == length do string[index] end
  def links([head|tail], length, index) do [head|links(tail, length, index+1)] end
end
