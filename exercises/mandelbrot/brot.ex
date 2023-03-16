defmodule Brot do
  def mandelbrot(c, m) do
    z0 = Complex.new(0, 0)
    test(0, z0, c, m)
  end
  def test(m, _z, _c, m) do 0 end
  def test(i, z, c, m) do
    if Complex.abs(z) <= 2.0 do
      z1 = Complex.add(Complex.sqr(z), c)
      test(i + 1, z1, c, m)
    else i end
  end
end
