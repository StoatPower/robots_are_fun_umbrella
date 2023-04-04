defmodule RobotsAreFun.Fleet.Robot do
  @moduledoc """
  A definition of a `Robot`.
  """

  @enforce_keys [:id, :battery_level, :x, :y]
  @derive [RobotsAreFun.Util.Position]
  defstruct ~w(id battery_level x y)a

  @typedoc """
  A robot has the following properties:

  * `:id` - a simple identifier for the robot
  * `:battery_level` - from 0 to 100
  * `:x` - the robot's current `x` position
  * `:y` - the robot's current `y` position
  """
  @type t() :: %__MODULE__{
    id: binary(),
    battery_level: non_neg_integer(),
    x: non_neg_integer(),
    y: non_neg_integer()
  }

  @doc """
  Returns whether or not the robot position is valid.
  """
  defguard valid_pos?(value)
    when is_integer(value.x)
      and is_integer(value.y)
      and value.x >= 0
      and value.y >= 0

  @doc """
  Returns whether or not the robot is valid.
  """
  defguard valid_robot?(value)
    when is_binary(value.id)
      and is_integer(value.battery_level)
      and value.battery_level >= 0
      and value.battery_level <= 100
      and valid_pos?(value)
end
