defmodule RobotsAreFun.Util do
  @moduledoc """
  Utility functions.
  """

  @type coordinate() :: {integer(), integer()}

  @doc """
  Calculates distance given two coordinates.
  """
  @spec calculate_distance(coordinate(), coordinate()) :: float()
  def calculate_distance({x1, y1}, {x2, y2}),
    do: :math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

  @doc """
  Normalizes a number using the min-max technique.
  """
  @spec min_max_norm(number(), {number(), number()}, {float(), float()}) :: float()
  def min_max_norm(x, {x_min, x_max}, {t_min, t_max}) do
    (x - x_min) / (x_max - x_min) * (t_max - t_min) + t_min
  end
end
