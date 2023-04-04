defmodule RobotsAreFunWeb.RobotJSON do
  alias RobotsAreFun.Fleet.{AssignedRobot, Robot}

  @doc """
  Renders a list of robots.
  """
  def index(%{robots: robots}) do
    %{data: for(robot <- robots, do: data(robot))}
  end

  @doc """
  Renders a single robot.
  """
  def show(%{robot: robot}) do
    %{data: data(robot)}
  end

  defp data(%Robot{} = robot) do
    %{
      robotId: robot.id,
      batteryLevel: robot.battery_level,
      x: robot.x,
      y: robot.y
    }
  end

  defp data(%AssignedRobot{} = robot) do
    %{
      robotId: robot.id,
      distanceToGoal: truncate_distance(robot.distance_to_load, 2),
      batteryLevel: robot.battery_level
    }
  end

  defp truncate_distance(distance, decimals) do
    distance
    |> :erlang.float_to_binary([decimals: decimals])
    |> String.to_float()
  end
end
