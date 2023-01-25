defmodule EnvTree do
  def new() do nil end

  def add(nil, key, value) do {:node, key, value, :nil, :nil} end
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end
  def add({:node, k, v, left, right}, key, value) do
    if key < k do
      {:node, k, v, add(left, key, value), right}
    else
      {:node, k, v, left, add(right, key, value)}
    end
  end

  def lookup(nil, _) do nil end
  def lookup({:node, key, value, _, _}, key) do {key, value} end
  def lookup({:node, k, _, left, right}, key) do
    if key < k do
      lookup(left, key)
    else
      lookup(right, key)
    end
  end

  # Didn't find the matching key
  def remove(nil, _) do nil end
  # Found the correct node to delete, and there is no left branch
  # Means that the right branch of this node (node to be deleted)
  # should replace the right branch of the node above this node.
  def remove({:node, key, _, nil, right}, key) do right end
  # Found the correct node, and there is no right branch
  # The left branch of this is sent to the node above.
  def remove({:node, key, _, left, nil}, key) do left end
  # Get the value from the node to be swapped, also get
  # a node which contains the nodes under the node to be
  # swapped.
  def remove({:node, key, _, left, right}, key) do
    {key, value, rest} = leftmost(right)
    {:node, key, value, left, rest}
  end
  # Move down the left branch if the key is lower than
  # current node.
  def remove({:node, k, v, left, right}, key) do
    if key < k do {:node, k, v, remove(left, key), right}
    else {:node, k, v, left, remove(right, key)} end
  end
  # Return the leftmost node's key, value and right branch.
  # This leftmost node, will be the one to be swapped, and
  # it's right branch will be directed to as the node to be
  # swapped right branch.
  def leftmost({:node, key, value, nil, rest}) do {key, value, rest} end
  # Find the perfect replacement for the node to be deleted
  # Is found in the nodes right branches leftmost node.
  # 'rest' is the leftmost's nodes right branch.
  def leftmost({:node, k, v, left, right}) do
    {key, value, rest} = leftmost(left)
    {key, value, {:node, k, v, rest, right}}
  end
end



# {:node, :f, 1, {:node, :e, 2, {:node, }}}

# {key, value, rest} = leftmost(18) -> node: key, value, left, ...rest...

# {key, value, rest}


# {:node, 20, 20, {:node, 10, 10, nil, nil}, {:node, 100, 100, {:node, 90, 90, {:node, 80, 80,nil , {:node, 85, 85, nil, {:node, 86, 86, nil, nil}}}, nil}, nil}}

#                   {:node, 20, 20,
# {:node, 10, 10, nil, nil}, {:node, 100, 100,
#                   {:node, 90, 90,
#           {:node, 80, 80, nil ,
#                   {:node, 85, 85, nil,
#                           {:node, 86, 86, nil, nil}}}, nil}, nil}}


# {:node, 20, 20, {:node, 10, 10, nil, nil}, {:node, 100, 100, {:node, 90, 90, {:node, 80, 80,nil , {:node, 85, 85, nil, {:node, 86, 86, nil, nil}}}, nil}, nil}}

#               {:node, 80, 80,
#{:node, 10, 10, nil, nil}, {:node, 100, 100,
#               {:node, 90, 90,
#     {:node, 85, 85, nil,
#             {:node, 86, 86, nil, nil}}}, nil}, nil}}, nil}

#{:node, 80, 80, {:node, 10, 10, nil, nil}, {:node, 100, 100, {:node, 90, 90, {:node, 85, 85, nil, {:node, 86, 86, nil, nil}}, nil}, nil}}

#{:node, 80, 80, {:node, 10, 10, nil, nil}, {:node, 100, 100, {:node, 90, 90, {:node, 85, 85, nil, {:node, 86, 86, nil, nil}}, nil}, nil}}
