defmodule RobotsAreFun.TestData do
  alias RobotsAreFun.Support.{Loads, Robots}

  def get_robots(), do: Robots.robots()

  def get_loads(), do: Loads.loads()

  def get_first_load(), do: hd(Loads.loads())
end
