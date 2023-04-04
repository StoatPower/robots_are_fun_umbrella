defmodule RobotsAreFun.Inventory.Load do
  @moduledoc """
  A definition of a `Load` that can be moved by a `RobotsAreFun.Fleet.Robot`.
  """

  @enforce_keys [:id, :x, :y]
  @derive [RobotsAreFun.Util.Position]
  defstruct ~w(id x y)a

  @typedoc """
  A load has the following properties:

  * `:id` - a simple identifier for the load
  * `:x` - the load's current `x` position, from 0 to 100
  * `:y` - the load's current `y` position, from 0 to 100
  """
  @type t() :: %__MODULE__{
          id: binary(),
          x: non_neg_integer(),
          y: non_neg_integer()
        }

  # @doc """
  # Returns whether or not the load position is valid.
  # """
  defguard valid_pos?(value)
           when is_integer(value.x) and
                  is_integer(value.y) and
                  value.x >= 0 and
                  value.y >= 0

  @doc """
  Returns whether or not the load is valid.
  """
  defguard valid_load?(value)
           when is_binary(value.id) and
                  valid_pos?(value)
end
