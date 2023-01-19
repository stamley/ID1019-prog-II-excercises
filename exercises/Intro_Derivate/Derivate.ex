defmodule Derivate do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: literal() |
  {:add, expr(), expr()} |
  {:mul, expr(), expr()} |
  {:exp, expr(), literal()} |
  {:log, expr()} |
  {:sqrt, expr()} |
  {:sin, expr()} |
  {:cos, expr()}


  def test1() do
    e = {:cos,
      {:mul, {:num, 2}, {:var, :x}}}
    d = derive(e, :x)
    # Calculates the derivated function with a given x
    c = calc(e, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated with 5: #{pprint(simplify(c))}\n")
  end

  def test2() do
    e = {:add,
      {:exp, {:num, 3}, {:var, :x}},
      {:num, 6}
    }
    d = derive(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
  end

  # Calculates function with given value of variable (n)
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:log, e}, v, n) do
    {:log, calc(e, v, n)}
  end
  def calc({:sqrt, e}, v, n) do
    {:exp, calc(e, v, n), {:num, 0.5}}
  end
  def calc({:sin, e}, v, n) do
    {:sin, calc(e, v ,n)}
  end
  def calc({:cos, e}, v, n) do
    {:cos, calc(e, v ,n)}
  end
  def calc(e) do e end

  # Performs the operations if possible, i.e contains no unknown
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:log, e}) do simplify_log({:log, simplify(e)}) end
  def simplify({:sin, e}) do simplify_sin({:sin, simplify(e)}) end
  def simplify({:cos, e}) do simplify_cos({:cos, simplify(e)}) end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_log({:log, {:num, 1}}) do {:num, 0} end
  def simplify_log({:log, {:num, n}}) do :math.log(n) end
  def simplify_log(e) do e end

  def simplify_sin({:sin, {:num, n}}) do {:num, :math.sin(n)} end
  def simplify_sin(e) do e end
  def simplify_cos({:cos, {:num, n}}) do {:num, :math.cos(n)} end
  def simplify_cos(e) do e end

  # derives a given function.
  def derive({:num, _}, _) do {:num, 0} end
  def derive({:var, v}, v) do {:num, 1} end
  def derive({:var, _}, _) do {:num, 0} end
  def derive({:add, e1, e2}, v) do
    {:add, derive(e1, v), derive(e2, v)}
  end
  def derive({:mul, e1, e2}, v) do
    {:add, {:mul, derive(e1, v), e2}, {:mul, e1, derive(e2, v)}}
  end
  def derive({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n - 1}}},
      derive(e, v)}
  end
  def derive({:log, {:num, _}}, _) do {:num, 0} end
  def derive({:log, e}, v) do {:mul, derive(e, v), {:exp, e, {:num, -1}}} end
  def derive({:sqrt, {:num, _}}, _) do {:num, 0} end
  def derive({:sqrt, e}, v) do {:mul, {:mul, {:num, 0.5}, {:exp, e, {:num, -0.5}}}, derive(e, v)} end
  def derive({:sin, {:num, _}}, _) do {:num, 0} end
  def derive({:sin, e}, v) do {:mul, {:cos, e}, derive(e, v)} end
  def derive({:cos, {:num, _}}, _) do {:num, 0} end
  def derive({:cos, e}, v) do {:mul, {:mul, {:num, -1}, {:sin, e}}, derive(e, v)} end

  # Cleans upp the expression when printing
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "(#{pprint(e1)} * #{pprint(e2)})" end
  def pprint({:exp, e1, e2}) do "#{pprint(e1)}^(#{pprint(e2)})" end
  def pprint({:log, e}) do "ln(#{pprint(e)})" end
  def pprint({:sqrt, e}) do "sqrt(#{pprint(e)})" end
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end
  def pprint(e) do "#{e}" end

end
