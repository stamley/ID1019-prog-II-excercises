defmodule Day16 do

  def task() do
    start = :AA
    #rows = File.stream!("day16.csv")
    rows = sample()
    map = Map.new(parse(rows))

    closed = Enum.map((Enum.filter(map, fn({_,{rate,_}}) -> rate != 0 end)), fn({valve, _}) -> valve end)

    {max, path} = path(start, 30, closed, [], 0, map, [])
    {max, Enum.reverse(path)}
  end

  def path(_valve, 0, _closed, _open, _flow_rate, _map, path) do
    {0, path}
  end

  def path(_valve, min, [], _open, flow_rate, _map, path) do
    # All open valve's rate will be added to the total flow.
    {flow_rate * min, path}
  end

  def path(valve, min, closed, open, flow_rate, map, path) do
    # Receive rate and links for the active valve
    {rate, tunnels} = map[valve]

    # If the current valve is a member of the closed array
    # it can be opened
    {max, path_max} = if Enum.member?(closed, valve) do
      # Remove the valve from closed list
      closed_removed = List.delete(closed, valve)
      # Add it to the opened ones
      open_added = insert(open, valve)
      # Go down the path with new lists for open and closed.
      {max, path_max} = path(valve, min-1, closed_removed, open_added, flow_rate+rate, map, [valve|path])
      max = max + rate
      # Return one possible path
      IO.write("#{max} ")
      {max, path_max}
    else
      # If the current valve already is opened, the current rate is
      # multiplied with the minutes.
      # (Will result in too much?, ex: 30 * 28, 35 * 27)
      {flow_rate * min, path}
    end

    Enum.reduce(tunnels, {max, path_max},
      fn(next, {max, path_max}) ->
        {max_next, path_max_next} = path(next, min-1, closed, open, flow_rate, map, path)
        max_next = max_next + flow_rate
        if max_next > max do
          {max_next, path_max_next}
        else
          {max, path_max}
        end
      end)
  end

  def insert([], valve) do [valve] end
  def insert([v|rest], valve) when v < valve do  [v|insert(rest, valve)] end
  def insert(open, valve) do  [valve|open] end





  ##  {:DD, {20, [:CC, :AA, :EE]}

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
