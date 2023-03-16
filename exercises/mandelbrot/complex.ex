defmodule Complex do

  def new(r, i) do {:c, r, i} end
  def add({:c, r1, i1}, {:c, r2, i2}) do {:c, r1 + r2, i1 + i2} end
  def sqr({:c, r, i}) do {:c, :math.pow(r, 2) - :math.pow(i, 2), 2 * r * i} end
  def abs({:c, r, i}) do :math.sqrt(:math.pow(r,2) + :math.pow(i,2)) end
end
