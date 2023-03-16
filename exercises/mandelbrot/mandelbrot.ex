defmodule Mandelbrot do
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Complex.new(x + k * (w - 1), y - k * (h - 1))
    end

    rows(width, height, trans, depth, [])
  end
  def rows(_, 0, _, _, rows) do rows end
  def rows(width, height, trans, depth, rows) do
    row = row(width, height, trans, depth, [])
    rows(width, height-1, trans, depth, [row | rows])
  end

  def row(0, _, _, _, row) do row end
  def row(width, height, trans, depth, row) do
    c = trans.(width, height)
    result = Brot.mandelbrot(c, depth)
    color = Color.convert(result, depth)
    row(width - 1, height, trans, depth, [color | row])
  end
end
