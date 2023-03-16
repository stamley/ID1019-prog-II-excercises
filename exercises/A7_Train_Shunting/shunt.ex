defmodule Shunt do
  def find([], []) do [] end
  def find(train1, [y|train2]) do
    # "few" implementation
    # If y already is in the correct position,
    # do nothing.
    [x|rest] = train1
    if x == y do find(rest, train2)
    else
      {before_y, after_y} = Train.split(train1, y)
      bef_len = length(before_y)
      aft_len = length(after_y)
      # One indexed, thats why there is plus one
      compress([{:one, aft_len+1}, {:two, bef_len}, {:one, -(aft_len+1)}, {:two, -bef_len}|find(Train.append(after_y, before_y), train2)])
    end
  end
    def compress(train) do
      new_train = rules(train)
      if new_train == train do
        train
      else
        compress(new_train)
      end
    end


    def rules([]) do [] end
    def rules([{:one, 0}|rest]) do rules(rest) end
    def rules([{:two, 0}|rest]) do rules(rest) end
    def rules([{:one, n}, {:one, m}|rest]) do rules([{:one, n+m}|rest]) end
    def rules([{:two, n}, {:two, m}|rest]) do rules([{:two, n+m}|rest]) end
    def rules([move|rest]) do [move|rules(rest)] end

    #def fewer(main, one, two, [y|train]) do
    #  cond do
    #    Train.member(main, y) ->
    #    Train.member(one, y) ->
    #    Train.member(two, y) ->
    #end
end
