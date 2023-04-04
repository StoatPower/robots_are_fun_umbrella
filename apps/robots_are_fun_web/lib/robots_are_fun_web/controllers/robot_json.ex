defmodule RobotsAreFunWeb.RobotJSON do
  alias RobotsAreFun.Fleet.Robot

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
end
