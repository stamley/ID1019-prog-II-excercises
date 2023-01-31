defmodule Eval do
  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | literal()
  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:quot, number(), number()}

  # Returns environment with given bindings of variables
  # Also finds given binding of a variable
  def env([{var, val}]) do [{{:var, var}, {:num, val}}] end
  def env([{var, val} | tail]) do
    [{{:var, var}, {:num, val}} | env(tail)]
  end
  def env({:var, var}, []) do {:var, var} end
  def env({:var, var}, [{{:var, var}, {:num, val}}|_tail]) do {:num, val} end
  def env(var, [_head|tail]) do env(var, tail) end

  # Finds the binding of a variable or reduces quotients
  def eval(:undefined, _) do :error end
  def eval({:num, n}, _env) do {:num, n} end
  def eval({:var, var}, env) do env({:var, var}, env) end
  def eval({:quot, n1, n2}, _) do reduce({:quot, n1, n2}) end

  # Evaluate two expressions and perform the operation
  def eval({:add, e1, e2}, env) do eval(add(eval(e1, env), eval(e2, env)), env) end
  def eval({:sub, e1, e2}, env) do eval(sub(eval(e1, env), eval(e2, env)), env) end
  def eval({:mul, e1, e2}, env) do eval(mul(eval(e1, env), eval(e2, env)), env) end
  def eval({:div, e1, e2}, env) do eval(divi(eval(e1, env), eval(e2, env)), env) end

  # Divide the quotient if possible, otherwise reduce it with gcd
  def reduce({:quot, _, 0}) do :error end
  def reduce({:quot, 0, _}) do {:num, 0} end
  def reduce({:quot, q1, q2}) when rem(q1, q2) == 0 do {:num, div(q1, q2)} end
  def reduce({:quot, q1, q2}) do
    gcd = Integer.gcd(q1, q2)
    {:quot, div(q1, gcd), div(q2, gcd)}
  end

  def add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def add({:quot, q1, q2}, {:num, n}) do {:quot, q1 + n * q2, q2} end
  def add({:num, n}, {:quot, q1, q2}) do {:quot, q1 + n * q2, q2} end
  def add({:quot, q1, q2}, {:quot, q3, q2}) do {:quot, q1 + q3, q2} end
  def add({:quot, q1, q2}, {:quot, q3, q4}) do {:quot, q1 * q4 + q3 * q2, q2 * q4} end

  def sub({:num, n1}, {:num, n2}) do {:num, n1 - n2} end
  def sub({:quot, q1, q2}, {:num, n}) do {:quot, q1 - n * q2, q2} end
  def sub({:num, n}, {:quot, q1, q2}) do {:quot, n * q2 - q1, q2} end
  def sub({:quot, q1, q2}, {:quot, q3, q2}) do {:quot, q1 - q3, q2} end
  def sub({:quot, q1, q2}, {:quot, q3, q4}) do {:quot, q1 * q4 - q3 * q2, q2 * q4} end

  def mul({:num, 0}, _) do {:num, 0} end
  def mul(_, {:num, 0}) do {:num, 0} end
  def mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
  def mul({:num, n}, {:quot, q1, q2}) do {:quot, n * q1, q2} end
  def mul({:quot, q1, q2}, {:num, n}) do {:quot, n * q1, q2} end
  def mul({:quot, q1, q2}, {:quot, q3, q4}) do {:quot, q1 * q3, q2 * q4} end

  def divi(_, {:num, 0}) do :undefined end
  def divi({:num, 0}, _) do {:num, 0} end
  def divi({:num, n1}, {:num, n2}) do {:quot, n1, n2} end
  def divi({:num, n}, {:quot, q1, q2}) do {:quot, n * q2, q1} end
  def divi({:quot, q1, q2}, {:num, n}) do {:quot, q1, q2 * n} end
  def divi({:quot, q1, q2}, {:quot, q3, q4}) do {:quot, q1 * q4, q2 * q3} end
end
