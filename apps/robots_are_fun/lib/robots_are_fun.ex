defmodule RobotsAreFun do
  @moduledoc """
  `RobotsAreFun` is the main backend context API.
  """
  require Logger
  import RobotsAreFun.Inventory.Load, only: [valid_load?: 1]
  alias RobotsAreFun.{Fitness, Fleet, Util}
  alias RobotsAreFun.Inventory.Load
  alias RobotsAreFun.Fleet.{AssignedRobot, Robot}

  @x_max_env "X_MAX"
  @y_max_env "Y_MAX"
  @default_x_max 100
  @default_y_max 100

  @doc """
  Returns the list of `RobotsAreFun.Fleet.Robot` in the `RobotsAreFun.Inventory.Load`.

  ## Examples

      iex> RobotsAreFun.show_fleet(get_fleet_fn: &RobotsAreFun.TestData.get_robots/0)
      {:ok,
        [
          %RobotsAreFun.Fleet.Robot{id: "111", battery_level: 21, x: 34, y: 86},
          %RobotsAreFun.Fleet.Robot{id: "14", battery_level: 66, x: 57, y: 88},
          %RobotsAreFun.Fleet.Robot{id: "222", battery_level: 66, x: 27, y: 86},
          %RobotsAreFun.Fleet.Robot{id: "25", battery_level: 51, x: 24, y: 8},
          %RobotsAreFun.Fleet.Robot{id: "27", battery_level: 91, x: 75, y: 11},
          %RobotsAreFun.Fleet.Robot{id: "333", battery_level: 70, x: 26, y: 87},
          %RobotsAreFun.Fleet.Robot{id: "43", battery_level: 59, x: 49, y: 20},
          %RobotsAreFun.Fleet.Robot{id: "47", battery_level: 0, x: 51, y: 38},
          %RobotsAreFun.Fleet.Robot{id: "7", battery_level: 24, x: 13, y: 66},
          %RobotsAreFun.Fleet.Robot{id: "74", battery_level: 45, x: 59, y: 43},
          %RobotsAreFun.Fleet.Robot{id: "75", battery_level: 97, x: 5, y: 33},
          %RobotsAreFun.Fleet.Robot{id: "8", battery_level: 62, x: 91, y: 96},
          %RobotsAreFun.Fleet.Robot{id: "90", battery_level: 28, x: 91, y: 62}
        ]
      }

  """
  @spec show_fleet(keyword()) :: {:ok, [Robot.t()]} | {:error, any()}
  def show_fleet(opts \\ []) do
    get_fleet_fn = Keyword.get(opts, :get_fleet_fn, &Fleet.get_fleet/0)
    case get_fleet_fn.() do
      {:ok, fleet} when is_map(fleet) ->
        {:ok, Map.values(fleet) |> Enum.sort_by(&(&1.id))}

      {:ok, fleet} when is_list(fleet) ->
        {:ok, fleet |> Enum.sort_by(&(&1.id))}

      {:ok, _invalid_fleet} ->
        {:error, "invalid fleet"}

      error ->
        error
    end
  end

  @doc """
  Given a `RobotsAreFun.Inventory.Load`, assigns the most suitable `RobotsAreFun.Fleet.Robot` to pick it up.

  ## Examples

      iex> load = RobotsAreFun.TestData.get_first_load()
      ...> RobotsAreFun.assign_robot_to_load(load, get_fleet_fn: &RobotsAreFun.TestData.get_robots/0)
      {:ok, %RobotsAreFun.Fleet.Robot{id: "222", battery_level: 66, x: 27, y: 86}}

      iex> load = RobotsAreFun.TestData.get_first_load()
      ...> get_fleet_fn = fn ->
      ...>   {:ok, robots} = RobotsAreFun.TestData.get_robots()
      ...>   new_robots = robots
      ...>   |> Enum.reduce(robots, fn {k, v}, acc ->
      ...>      updated_robot = %RobotsAreFun.Fleet.Robot{v | battery_level: 0}
      ...>      Map.put(acc, k, updated_robot)
      ...>   end)
      ...>   {:ok, new_robots}
      ...> end
      ...> RobotsAreFun.assign_robot_to_load(load, get_fleet_fn: fn -> get_fleet_fn.() end, show_assessments?: true)
      {:error,
        {:not_found,
          [
            %{distance: 60.00833275470999, fitness: 0, id: "90"},
            %{distance: 55.90169943749474, fitness: 0, id: "8"},
            %{distance: 61.40032573203501, fitness: 0, id: "75"},
            %{distance: 48.76474136094644, fitness: 0, id: "74"},
            %{distance: 30.479501308256342, fitness: 0, id: "7"},
            %{distance: 50.28916384272063, fitness: 0, id: "47"},
            %{distance: 67.26812023536856, fitness: 0, id: "43"},
            %{distance: 10.04987562112089, fitness: 0, id: "333"},
            %{distance: 84.53401682163222, fitness: 0, id: "27"},
            %{distance: 78.91767862779544, fitness: 0, id: "25"},
            %{distance: 9.0, fitness: 0, id: "222"},
            %{distance: 21.095023109728988, fitness: 0, id: "14"},
            %{distance: 2.0, fitness: 0, id: "111"}
          ]
        }
      }

  """
  @spec assign_robot_to_load(Load.t(), keyword()) :: {:ok, Robot.t() | {Robot.t(), [map()]}} | {:error, any()}
  def assign_robot_to_load(load, opts \\ [])

  def assign_robot_to_load(%Load{} = load, opts) when valid_load?(load) do
    get_fleet_fn = Keyword.get(opts, :get_fleet_fn, &Fleet.get_fleet/0)
    show_assesments? = Keyword.get(opts, :show_assessments?, false)

    with {:ok, fleet} <- get_fleet_fn.(),
         {:ok, [best_fit | _] = assessments} <- assess_robots(fleet, load),
         %Robot{} = robot <- Map.get(fleet, best_fit.id)
    do
      Logger.info(msg: "Assigned robot: #{robot.id}", robot: robot, distance: best_fit.distance, fitness: best_fit.fitness)

      assigned_robot = %AssignedRobot{
        id: robot.id,
        load_id: load.id,
        battery_level: robot.battery_level,
        distance_to_load: best_fit.distance
      }

      if show_assesments? == true do
        {:ok, {assigned_robot, assessments}}
      else
        {:ok, assigned_robot}
      end
    else
      {:error, error} ->
        {:error, error}

      {:not_found, assessments} ->
        if show_assesments? == true do
          {:error, {:not_found, assessments}}
        else
          {:error, :not_found}
        end

      :error ->
        {:error, "error assigning robot"}
    end
  end

  def assign_robot_to_load(load, _opts) do
    Logger.error(msg: "invalid %RobotsAreFun.Inventory.Load{}", load: load)
    {:error, "invalid load"}
  end

  @spec assess_robots(map(), Load.t()) :: {:ok, [map()]} | {:not_found, [map()]} | :error
  defp assess_robots(robots, %Load{} = load) when is_map(robots) and valid_load?(load) do
    options = get_options()

    robot_fits =
      robots
      |> Enum.reduce([], fn {id, robot}, acc ->
        case Fitness.assess_robot_fitness(robot, load, options) do
          {:ok, {distance, fitness}} ->
            [%{id: id, distance: distance, fitness: fitness} | acc]

          :error ->
            acc
        end
      end)
      |> Enum.sort_by(&(&1.fitness), :desc)

    if Enum.count(robot_fits) == 0 or Enum.all?(robot_fits, &(&1.fitness) <= 0) do
      {:not_found, robot_fits}
    else
      {:ok, robot_fits}
    end
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
