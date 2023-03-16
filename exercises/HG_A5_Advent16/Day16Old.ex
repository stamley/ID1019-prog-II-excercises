defmodule Day16Old do

  # para -> t
  def task() do
    #start = :AA
    rows = File.stream!("day16.csv")
    #rows = sample()
    #print(path(30, [], :AA, parse(rows), [], :false), 0)
    path(30, [], :AA, parse(rows), [], :false, :none)
  end

  #def print([]) do IO.puts("End") end
  #def print([head|tail]) do
  #  IO.puts(head)
  #  print(tail)
  #end

  def sum_of_rates([], 0) do :noop end
  def sum_of_rates([], acc) do acc end
  def sum_of_rates([{_, pressure}|tail], acc) do
    acc = acc + pressure
    sum_of_rates(tail, acc)
  end

  #def print({_, pressure}, acc) do
   # acc = acc + pressure
  #end




  # path
  # 1. Minutes left
  # 2. Current path
  # 3. Links to valve
  # 4. Map of all connections
  # 5. Collected pressure rates
  # 6. Activation is true or not.
  # 7. Maximum pressure amount


  # Om minuterna är slut, ge tillbaka motsvarande väg genom accu.
  def path(0, _, _, _, pressure_rates, _, _) do sum_of_rates(pressure_rates, 0) end
  # Första steget från :AA
  def path(min, [], :AA, graph, [], :false, _) do
    path(min, [], elem(graph[:AA], 1), graph, [], :false)
  end
  # Om gått ner för alla links
  #def path(_, _current, [], _, pressure_rates) do
    #IO.puts("End of link")
    #print(current_path)
    #print(pressure_rates, 0)
  #end
  # En hel link lista är traverserad
  def path(_, _, [], _, pressure_rates, _, _) do sum_of_rates(pressure_rates, 0) end
  # Gå ner i :AA's olika paths
  def path(min, [], [head|tail], graph, pressure_rates, _, max) do
    max = path(min-1, ["Going down path #{head}"], head, graph, pressure_rates, :false)
    if maxCan = path(min, ["init"], tail, graph, pressure_rates, :false) > max do max = maxCan end
  end
  # Gå ner i nuvarande path's paths, eller aktiverar valvet
  def path(min, current_path, [head|tail], graph, pressure_rates, :false, max) do
    if maxCan = path(min-1, current_path++["Going down path #{head}"], head, graph, update_press(pressure_rates, graph[head]), :false) > max do max = maxCan end
    if maxCan = path(min, current_path, tail, graph, pressure_rates, :false) > max do max = maxCan end
    if maxCan = path(min-1, current_path++["Activating valve #{head}"], tail, graph, update_press(pressure_rates, graph[head]), :true) > max do max = maxCan end
  end
  # Activating valve
  def path(min, current_path, [head|tail], graph, pressure_rates, :true) do
    path(min-1, current_path++["Going down path #{head}"], head, graph, update_press(pressure_rates, graph[head]), :false)
    path(min, current_path, tail, graph, pressure_rates, :false)
  end
  # Gå ner i last_links olika paths
  def path(min, current_path, last_link, graph, pressure_rates, :false) when is_atom(last_link) do
    path(min, current_path, elem(graph[last_link], 1), graph, pressure_rates, :false)
    #path(min, ["Going down path #{head}"], tail, graph, pressure_rates)
  end


  # Add the new pressure rate
  def update_press([], {pressure, _}) do
    [{pressure, pressure}]
  end
  # No new pressure rates added but they still need to update.
  def update_press([], :none) do [] end
  # Update all pressure rates when a new one is added.
  # Done at the same time as a path is gone down in
  def update_press([{old_pressure, updated}|tail], valve) do
    [{old_pressure, updated + old_pressure}|update_press(tail, valve)]
  end


  ## turning rows
  ##
  ##  "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE"
  ##
  ## into tuples
  ##
  ##  {:DD, {20, [:CC, :AA, :EE]}
  ##

  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end

  def sample() do
    ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
     "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
     "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
     "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
     "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
     "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
     "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
     "Valve HH has flow rate=22; tunnel leads to valve GG",
     "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
     "Valve JJ has flow rate=21; tunnel leads to valve II"]
  end



end
