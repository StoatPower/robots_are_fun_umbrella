defmodule RobotsAreFun.Fleet do
  @moduledoc """
  Fetch the fleet of default robots from SVT endpoint.
  """
  require Logger
  alias RobotsAreFun.Fleet.Robot

  @fleet_url_env "FLEET_URL"

  @default_url "https://60c8ed887dafc90017ffbd56.mockapi.io/robots"

  @doc """
  Returns the fleet of `RobotsAreFun.Fleet.Robot`s in a `map()`.
  """
  @spec get_fleet() :: {:ok, map()} | {:error, any()}
  def get_fleet() do
    with {:ok, %HTTPoison.Response{body: body}} <- request_fleet(),
         {:ok, fleet} <- Jason.decode(body) do
      {:ok, process_fleet(fleet)}
    else
      error ->
        Logger.error(error)
        {:error, "error fetching robot fleet"}
    end
  end

  @spec request_fleet() :: {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} | {:error, HTTPoison.Error.t}
  defp request_fleet(),
    do: HTTPoison.get(get_fleet_url())

  @spec process_fleet(list()) :: map()
  defp process_fleet(fleet) when is_list(fleet) do
    Enum.reduce(fleet, Map.new(), fn next, acc ->
      case process_robot(next) do
        {:ok, robot} -> Map.put(acc, robot.id, robot)
        :error -> acc
      end
    end)
  end

  @spec process_robot(map()) :: {:ok, Robot.t()} | :error
  defp process_robot(robot) when is_map(robot) do
    with {:ok, id} <- Access.fetch(robot, "robotId"),
         {:ok, battery_level} <- Access.fetch(robot, "batteryLevel"),
         {:ok, x} <- Access.fetch(robot, "x"),
         {:ok, y} <- Access.fetch(robot, "y") do
      {:ok,
       %Robot{
         id: id,
         battery_level: battery_level,
         x: x,
         y: y
       }}
    end
  end

  @spec get_fleet_url() :: binary()
  defp get_fleet_url() do
    case System.fetch_env(@fleet_url_env) do
      {:ok, url} -> url

      :error ->
        @default_url
    end
  end
end
