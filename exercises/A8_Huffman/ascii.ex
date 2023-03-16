defmodule Ascii do
  def ascii() do
    for n <- 32..255 do
      List.to_string([n])
    end
  end
  def asc(128) do " " end
  def asc(n) do
    "#{List.to_string([n])}" <> asc(n+1)
  end
end
