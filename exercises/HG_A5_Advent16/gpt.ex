defmodule Valve do
  defstruct id: "", flow_rate: 0, tunnels: []
end

defmodule Solution do
  def solve(input) do
    valves = parse_input(input)
    opened = MapSet.new(["AA"])
    pressure_released = 0
    for minute <- 1..29 do
      next_valves = get_reachable_valves(valves, opened)
        |> MapSet.difference(opened)
        |> MapSet.to_list()
        |> Enum.sort_by(&(&1.flow_rate), &>=/2)
      if !Enum.empty?(next_valves) do
        next_valve = hd(next_valves)
        opened = MapSet.put(opened, next_valve.id)
        pressure_released = pressure_released + minute * next_valve.flow_rate
      end
    end
    pressure_released
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_valve/1)
    |> Enum.into(%{})
  end

  def parse_valve(line) do
    [id_str, flow_rate_str, tunnels_str] = String.split(line, "; ")
    tunnels = String.split(tunnels_str, ", ")
    tunnels = Enum.map(tunnels, fn t ->
      String.replace(t, ["tunnels lead to valves ", "."], "")
    end)
    %Valve{id: id_str, flow_rate: String.to_integer(flow_rate_str), tunnels: tunnels}
  end

  def get_reachable_valves(valves, opened) do
    opened
    |> MapSet.to_list()
    |> Enum.map(&get_reachable_valves_from(valves, &1))
    |> Enum.reduce(MapSet.new(), &MapSet.union(&1, &2))
  end

  def get_reachable_valves_from(valves, id) do
    valve = Map.get(valves, id)
    tunnels = valve.tunnels
    tunnels
    |> Enum.filter(&!MapSet.member?(opened, &1))
    |> Enum.map(&Map.get(valves, &1))
    |> Enum.filter(&(&1.flow_rate > 0))
    |> Enum.into(MapSet.new())
  end
end
