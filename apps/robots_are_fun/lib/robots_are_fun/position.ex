defprotocol RobotsAreFun.Position do
  @moduledoc """
  A protocol that can be shared by anything that has an `{x, y}` position.
  """

  @doc """
  Returns the {x, y} position.
  """
  # @spec position(any()) :: {integer(), integer()} | nil
  def position(value)
end

defimpl RobotsAreFun.Position, for: Any do
  def position(map) when is_map_key(map, :x) and is_map_key(map, :y),
    do: {map.x, map.y}

  def position(_), do: nil
end
