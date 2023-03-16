defmodule Day16 do
  def task() do
    #start = :AA
    #rows = File.stream!("day16.csv")
    rows = sample()
    {_links, rates} = parse(rows)

    # [AA: 0, BB: 3]
    # [
    # AA: [BB: 2, CC: 4]
    # BB: [CC: 1, DD: 3]
    # ]
    # Saved in "dists"

    #links |> IO.inspect()
    #rates |> IO.inspect()
    important = Enum.filter(rates, fn({name, rate}) -> rate != 0 || name == :AA end) |> IO.inspect()
    non_empty = List.delete(important, {:AA, 0})
    non_empty |> IO.inspect()

    #distances = Map.new()

    # distances = [ AA: [BB: 5, CC: 6] , BB: [CC: 5, DD: 6] ]
    #Enum.reduce(important, fn({name, rate}) ->

      # Add itself and aa with 0 distance, irrelevant
      #distances = distances |> Map.puts(name, {name, 0}) |> Map.puts(name, {:AA, 0})

      #queue = queue([], {name, rate})



    #end)

  end

  # 1. queue of nodes to visit
  # 2. array which will end up having the destination from each
  # "important" node pair
  # 3. list of each node's connections to other nodes
  # 4. list of each node's flow rates
  # 5. Already visited nodes
  # 6. name and rate of current node

  def calc_distances([], distances, _links, _rates, _visited, {name, _rate}) do
    Map.delete(distances, name)
    if name != :AA do Map.delete(distances, :AA) end
  end
  def calc_distances(queue, distances, links, rates, visited, {name, rate}) do
    # Current node
    {{distance, position}, queue} = pop(queue)
    # For all links in the current node
    visited_new = visited
    Enum.reduce(links[position], fn(neighbour) ->
      # If it isn't already a member of the visited array
      if !Enum.member?(visited, neighbour) do
        visited_new = [neighbour|visited]
        if rates[neighbour] != 0 do
          distances[name] |> Map.puts(neighbour, distance + 1)
        end
        queue = queue(queue, {distance + 1, neighbour})

      end
    end)
    calc_distances(queue, distances, links, rates, visited_new, {name, rate})
    distances
  end

  def pop([head|tail]) do {head, tail} end
  def queue([], x) do [x] end
  def queue(queue, x) do queue ++ x end

  def parse(input) do
    {Enum.map(input, fn(row) ->
      [valve, _rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, valves}
    end),
    Enum.map(input, fn(row) ->
      [valve, rate, _valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      {valve, rate}
    end)}
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
