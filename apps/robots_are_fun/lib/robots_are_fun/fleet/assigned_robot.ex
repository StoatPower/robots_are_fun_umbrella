defmodule RobotsAreFun.Fleet.AssignedRobot do
  @moduledoc """
  A definition for a `Robot` that has been assigned to a load.
  """
  @enforce_keys [:id, :load_id, :battery_level, :distance_to_load]
  defstruct ~w(id load_id battery_level distance_to_load)a

  @typedoc """
  An assigned robot has the following properties:

  * `:id` - a simple identifier for the robot
  * `:load_id` - the id of the `RobotsAreFun.Fleet.Load` it
      has been assigned to
  * `:battery_level` - from 0 to 100
  * `:distance_to_load` - the distance between it and the
      assigned load

  """
  @type t() :: %__MODULE__{
    id: binary(),
    load_id: binary(),
    battery_level: non_neg_integer(),
    distance_to_load: number()
  }

end
