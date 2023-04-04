defmodule RobotsAreFun do
  @moduledoc """
  RobotsAreFun keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  require Logger
  import RobotsAreFun.Load, only: [valid_load?: 1]
  alias RobotsAreFun.{Fitness, Fleet, Load, Robot, Util}

  @x_max_env "X_MAX"
  @y_max_env "Y_MAX"
  @default_x_max 100
  @default_y_max 100

  @doc """
  Given a `RobotsAreFun.Load`, assigns the most suitable `RobotsAreFun.Robot` to pick it up.

  ## Examples

      iex> load = %RobotsAreFun.Load{load_id: "1", x: 23, y: 55}
      ...>

  """
  @spec assign_robot_to_load(Load.t(), keyword()) :: {:ok, Robot.t()} | {:error, any()}
  def assign_robot_to_load(load, opts \\ [])

  def assign_robot_to_load(%Load{} = load, opts) when valid_load?(load) do
    get_fleet_fn = Keyword.get(opts, :get_fleet_fn, &Fleet.get_fleet/0)

    with {:ok, fleet} <- get_fleet_fn.(),
         {:ok, [best_fit | _]} <- assess_robots(fleet, load),
         %Robot{} = robot <- Map.get(fleet, best_fit.robot_id)
    do
      Logger.info(msg: "Assigned robot: #{robot.robot_id}", robot: robot, distance: best_fit.distance, fitness: best_fit.fitness)
      {:ok, robot}
    else
      {:error, error} ->
        {:error, error}

      _ ->
        {:error, "failed to assign robot"}
    end
  end

  def assign_robot_to_load(load, _opts) do
    Logger.error(msg: "invalid %RobotsAreFun.Load{}", load: load)
    {:error, "failed to assign robot"}
  end

  @spec assess_robots(map(), Load.t()) :: {:ok, [map()]} | :error
  defp assess_robots(robots, %Load{} = load) when is_map(robots) and valid_load?(load) do
    options = get_options()

    robot_fits =
      robots
      |> Enum.reduce([], fn {robot_id, robot}, acc ->
        case Fitness.assess_robot_fitness(robot, load, options) do
          {:ok, {distance, fitness}} ->
            [%{robot_id: robot_id, distance: distance, fitness: fitness} | acc]

          :error ->
            acc
        end
      end)
      |> Enum.sort_by(&(&1.fitness), :desc)

    {:ok, robot_fits}
  end

  defp assess_robots(_, _), do: :error

  @spec get_options() :: keyword()
  defp get_options() do
    x_max =
      case System.fetch_env(@x_max_env) do
        {:ok, result} -> String.to_integer(result)

        :error ->
          @default_x_max
      end

    y_max =
      case System.fetch_env(@y_max_env) do
        {:ok, result} -> String.to_integer(result)

        :error ->
          @default_y_max
      end

    distance_max = Util.calculate_distance({0, 0}, {x_max, y_max})
    [distance_max: distance_max]
  end
end
