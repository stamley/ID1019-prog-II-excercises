defmodule EnvList do
  def new() do [] end
  # Each "head" that doesn't match is added to the left side of the array,
  # and if the key doesn't exist, it is added to the end of the new array.
  # Otherwise the corresponding key's value is changed, and the remaining
  # elements are added to the right side of the array.
  def add([], key, value) do [{key, value}] end
  def add([{key, _}| t], key, value) do [{key, value} | t] end
  def add([h|t], key, value) do [h|add(t, key, value)] end

  # Check the head, and discard if it is not equal, otherwise return tuple.
  def lookup([], _) do nil end
  def lookup([{key, value}|_], key) do {key, value} end
  def lookup([_|t], key) do lookup(t, key) end

  def remove([], _) do [] end
  def remove([{key, _}|t], key) do t end
  def remove([h|t], key) do [h|remove(t, key)] end
end
