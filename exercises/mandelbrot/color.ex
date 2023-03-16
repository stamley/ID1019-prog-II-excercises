defmodule Color do
  def convert(depth, max) do
    val = 1

    f = depth/max
    a = f * 4
    x = trunc(a)
    y = trunc(1 * (a - x))
    case x do
      0 -> {y, 0, 0}
      1 -> {val, y, 0}
      2 -> {val - y, val, 0}
      3 -> {0, val, y}
      4 -> {0, val - y, val}
    end
  end
end
