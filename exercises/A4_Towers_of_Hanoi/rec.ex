defmodule Rec do
  def hej(0, _) do [] end
  def hej(x, t) when x > 0 do
    t = t + 1
    hej(x-1, t) ++ [{:fuckoff, x, t, "Run Car"}] ++ hej(x-1, t)
  end
end
