defmodule RobotsAreFun.Robot do
  @moduledoc """
  A definition of a `Robot`.

  A robot has the following properties:

  * `:robot_id` - a simple identifier for the robot
  * `:battery_level` - from 0 to 100 (presumably)
  * `:x` - the robot's current `x` position
  * `:y` - the robot's current `y` position
  """
  defstruct ~w(robot_id battery_level x y)a
end
