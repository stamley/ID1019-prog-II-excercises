defmodule EnvList do
  def new() do [] end
  
  def add()
  def add(map, key, value) do [map | {key, value}] end
  def lookup(map, key) do end
  def remove(key, map) do end
end
