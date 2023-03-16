defmodule Carlo do

  def est(num, rad) do
    # Radius needs to be sufficiently large to give accurate results
    rounds(num, 1000, rad, 0)
    IO.puts("Leibniz: ")
    IO.puts(leibniz())
  end

  def dart(r) do
    # Dart landing on point (x, y), is it in circle?
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r, 2) > (:math.pow(x, 2) + :math.pow(y, 2))
  end
  # Number of darts that hit the circle
  def throw_darts(0, _, a) do a end
  def throw_darts(darts, rad, a) do
    if dart(rad) do
      # The dart landed in the circle
      throw_darts(darts-1, rad, a + 1)
    else
      throw_darts(darts-1, rad, a)
    end
  end

  def rounds(0, darts, _, a) do 4*a/darts end
  def rounds(round, darts, radius, a) do
    a = throw_darts(darts, radius, a)
    darts = darts * 2
    pi = 4*a/darts
    :io.format("round = ~4w, pi = ~14.10f, diff = ~14.10f\n", [round, pi, (pi - :math.pi())])
    #:io.format("~4w $ ~14.10f $ ~14.10f\\\\ \n", [round, pi, (pi - :math.pi())])
    rounds(round-1, darts, radius, a)
  end

  def leibniz() do
    4 * Enum.reduce(0..1000000, 0, fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)
  end

end
