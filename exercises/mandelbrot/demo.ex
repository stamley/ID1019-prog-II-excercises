 defmodule Demo do
  def demo() do
    #small(-2.6, 1.2, 1.2)
    small(-0.6, 1.3, 1.4)
  end
  def small(x0, y0, xn) do
    width = 3840
    height = 1920
    depth = 48
    k = (xn - x0) / width
    image = Mandelbrot.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
  end
end
