defmodule RobotsAreFun.Fitness do
  @moduledoc """
  Determines a `RobotsAreFun.Fleet.Robot`'s fitness for picking up a given `RobotsAreFun.Inventory.Load`.
  """

  import RobotsAreFun.Util.Position, only: [position: 1]
  import RobotsAreFun.Fleet.Robot, only: [valid_robot?: 1]
  import RobotsAreFun.Inventory.Load, only: [valid_load?: 1]
  alias RobotsAreFun.Util
  alias RobotsAreFun.Inventory.Load
  alias RobotsAreFun.Fleet.Robot

  @battery_max 100
  @threshold 10

  @default_options [
    distance_max: 141.4213562373095 # :math.sqrt(100**2 + 100**2)
  ]

  @typep distance() :: float()
  @typep fitness() :: float()

  @doc """
  Assesses a `RobotsAreFun.Fleet.Robot`'s fitness for picking up a `RobotsAreFun.Inventory.Load`.

  Returns the calculated `distance` to the `load`, and its weighted `fitness` score.

  ## Options

      * `:distance_max` - the maxiumum distance a robot can travel, defaults to `100`.

  """
  @spec assess_robot_fitness(Robot.t(), Load.t(), keyword()) :: {:ok, {distance(), fitness()}} | :error
  def assess_robot_fitness(robot, load, opts \\ [])

  def assess_robot_fitness(robot, load, []),
    do: assess_robot_fitness(robot, load, @default_options)

  def assess_robot_fitness(%Robot{} = robot, %Load{} = load, opts)
      when valid_robot?(robot) and valid_load?(load) do
    distance_max = Keyword.fetch!(opts, :distance_max)

    {distance, fitness} =
      robot
      |> calculate_fitness(load, distance_max)

    {:ok, {distance, fitness}}
  end

  def assess_robot_fitness(_, _, _), do: :error

  @spec calculate_fitness(Robot.t(), Load.t(), distance()) :: {distance(), fitness()}
  defp calculate_fitness(robot, load, distance_max) do
    battery_level = robot.battery_level
    distance = Util.calculate_distance(position(robot), position(load))

    overall_fitness =
      cond do
        distance > @threshold and distance <= distance_max and battery_level > 0 ->
          1.0 - Util.min_max_norm(distance, {@threshold, distance_max}, {0.1, 1.0})

        distance >= 0 and distance <= @threshold and battery_level > 0 ->
          0.9 + Util.min_max_norm(battery_level, {0, @battery_max}, {0.0, 0.1})

        true ->
          0
      end

    {distance, overall_fitness}
  end
end
