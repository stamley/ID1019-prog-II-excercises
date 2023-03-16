
 # def throw_darts_dyn(0, _, a, _) do a end
  #def throw_darts_dyn(k, r, a, dyn) do
   # if dart(r, dyn) do
      # The dart landed in the circle
    #  throw_darts(k-1, r, a + 1)
    #else
     # throw_darts(k-1, r, a)
    #end
  #end

  def test() do
    #size = 10

    #list = Enum.map(Enum.to_list(0..size), fn(x) -> generate(x, size) end)
    #list = Map.new(Enum.to_list(0..size), fn(x) -> generate(x, size) end)

    #list |> IO.inspect()
    #Map.values(list)
    #list[1][{1,2}] |> IO.inspect()
  end

  def generate(x, size) do
    for y <- 0..size do
      {{x, y}, false}
    end
  end

  def generate_pairs(n) do
    for x <- 0..n do
      for y <- 0..n do
        {{x, y}, false}
      end
    end
  end
