defmodule Philosopher do
  # Either thinking, waiting for cstick or eating
  # Thinking -> Does nothing until eat
  #   Request left and right cstick
  #   if ok -> eat for awhile, then return sticks.


  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end
  # 1. hunger: the number of times the Philosopher should eat before it
  # sends a :done message to the controller process.
  # 2 and 3. right and left: the process identifiers of the two chopsticks.
  # 4. name: a string that is the name of the philosopher.
  # 5. ctrl: a controller process that should be informed when the philosopher is done.
  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> init(hunger, right, left, name, ctrl))
  end
end
