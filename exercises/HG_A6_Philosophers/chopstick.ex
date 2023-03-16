defmodule Chopstick do
  def start() do
    cstick = spawn_link(fn -> init() end)
    {:cstick, cstick}
  end
  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit -> :ok
    end
  end
  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  def request(cstick, timeout) do
    send(cstick, :request)
    receive do
      :granted -> :ok
    after timeout -> :no
    end
  end
end
