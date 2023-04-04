defmodule RobotsAreFun.BestRobot do
  @moduledoc """
  Defines the problem for determining the best robot to send to a given load.

  ## Rules and Constraints

  1. For robots between 11 and 100 units from the `RobotsAreFun.Load`, the fitness
      function should put equal weight on distance (closer is better) and battery
      level (higher is better).
  2. For `RobotsAreFun.Robot`s between 0 and 10 units of the `RobotsAreFun.Load`
      with any amount of battery level remaining, they should have the highest
      weight in the fitness function, regardless of their distance from the `RobotsAreFun.Load`.
  3. For `RobotsAreFun.Robot`s between 0 and 10 units of the `RobotsAreFun.Load`
      with no battery level remaining, they should have zero weight in the fitness function.
  4. For `RobotsAreFun.Robot`s further than `distance_max` units from the `RobotsAreFun.Load`,
      they should have zero weight in the fitness function.
  5. For `RobotsAreFun.Robot`s between 10 and 11 units from the `RobotsAreFun.Load`,
      they should have a weight that is scaled linearly based on their battery level,
      with a minimum weight of 0.5 and a maximum weight of 1.0.
  6. For `RobotsAreFun.Robot`s further than 10 units from the `RobotsAreFun.Load` but
      closer than `distance_max` units, they should have a weight that is scaled linearly
      based on their distance from the `RobotsAreFun.Load`, with a maximum weight of 0.5.
  7. For all `RobotsAreFun.Robot`s, if two or more `RobotsAreFun.Robot`s have the same
      weight, the fitness function should choose the one with the higher battery level.
  """

  @behaviour RobotsAreFun.Solver.Problem
  alias RobotsAreFun.Solver.Chromosome
  import RobotsAreFun.Position, only: [position: 1]

  @type coordinate() :: {number(), number()}
  @type distance() :: float()

  @target_fitness 1.0

  @doc """
  Generates a genotype (possible solution).
  """
  @impl true
  def genotype(opts \\ []) do
    robot = Keyword.fetch!(opts, :robot)
    genes = Map.from_struct(robot)
    %Chromosome{genes: genes, size: 1}
  end

  @doc """

  """
  @impl true
  def fitness_function(%Chromosome{genes: genes}, opts \\ []) do
    # get our metadata
    target_load = Keyword.fetch!(opts, :load)
    distance_max = Keyword.fetch!(opts, :distance_max)

    # calculate our distance
    distance = calculate_distance(position(genes), position(target_load))

    # normalize our distance and our battery_level
    distance_norm = 1.0 - distance / distance_max
    battery_norm = genes.battery_level / 100.0

    # setup a penalty for zero battery
    battery_penalty =
      if battery_norm == 0.0, do: -1.0, else: 0.0

    # setup a penalty for out of range
    distance_penalty =
      if distance_norm < 0.0, do: -1.0, else: 0.0

    # calculate our weights based on our rules and constraints
    {battery_weight, distance_weight} =
      cond do
        distance_norm > 0.1 and distance_norm <= 1.0 ->
          {battery_norm, (1.0 - distance_norm) * 0.1}

        distance_norm >= 0.0 and distance_norm <= 0.1 ->
          {battery_norm * 0.1, 1.0}

        true ->
          {battery_norm, 0.0}
      end

    # overall fitness
    battery_penalty + distance_penalty + battery_weight + distance_weight
  end

  @spec calculate_distance(coordinate(), coordinate()) :: distance()
  defp calculate_distance({x1, y1}, {x2, y2}),
    do: :math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

end
