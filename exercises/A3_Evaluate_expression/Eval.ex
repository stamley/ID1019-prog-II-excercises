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
  def env([]) do nil end
  def env([{var, val} | tail]) do
    [{{:var, var}, {:num, val}} | env(tail)]
  end
  def env({:var, var}, []) do var end
  # If there exists a binding in the environment return the value
  def env({:var, var}, [{{:var, var}, {:num, val}}|_tail]) do val end
  # Continue looking...
  def env(var, [head|tail]) do env(var, tail) end


  def eval({:num, n}, _) do n end
  # If the variable has a binding, find it
  def eval({:var, var}, env) do env({:var, var}, env) end
  # Evaluate two expressions and then add them together
  def eval({:add, e1, e2}, env) do add(eval(e1), eval(e2)) end
  def eval({:sub, e1, e2}, env) do sub(eval(e1), eval(e2)) end
  def eval({:mul, e1, e2}, env) do mul(eval(e1), eval(e2)) end
  def eval({:div, e1, e2}, env) do div(eval(e1), eval(e2)) end

  def add({:num, n1}, {:num, n2}) do n1 + n2 end
  def sub({:num, n1}, {:num, n2}) do n1 - n2 end
  def mul({:num, n1}, {:num, n2}) do n1 * n2 end
  # Simplify this multiplication, if n1*q1/q2 can be reduced,
  # it should be.
  # Possible without checking division with each natural number?
  def mul({:num, n1}, {:q, q1, q2}) do {:q, n1*q1, q2} end
  def mul({:num, n1}, {:q, q1, q2}) do {:q, n1*q1/2, q2/2} when rem(n1*q1, 2) == 0 and rem(q2, 2) == 0  end
  def div({:num, n1}, {:num, n2}) do n1 / n2 when rem(n1, n2) == 0 end
  def div({:num, n1}, {:num, n2}) do {:quot, n1, n2} end

  # Add, Sub, Mul, Div
  # Numbers might be rational...
  # Reduce rational numbers as much as possible 2*3/4 should not be
  # 6/4 but 3/2

end
