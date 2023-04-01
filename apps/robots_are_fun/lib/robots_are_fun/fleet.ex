defmodule RobotsAreFun.Fleet do
  @moduledoc """
  Fetch the fleet of default robots from SVT endpoint.
  """
  require Logger
  alias RobotsAreFun.Robot

  @fleet_endpoint "https://60c8ed887dafc90017ffbd56.mockapi.io/robots"

  def get_fleet() do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(@fleet_endpoint),
         {:ok, fleet} <- Jason.decode(body)
    do
      process_fleet(fleet)
    else
      error ->
        Logger.error(error)
        raise "Error fetching robot fleet!"
    end
  end

  defp process_fleet(robots) when is_list(robots),
    do: Enum.map(robots, &process_robot/1)

  defp process_robot(robot) when is_map(robot) do
    %Robot{
      :robot_id => robot["robotId"],
      :battery_level => robot["batteryLevel"],
      :x => robot["x"],
      :y => robot["y"]
    }
  end
end
