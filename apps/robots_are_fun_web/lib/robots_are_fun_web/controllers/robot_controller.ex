defmodule RobotsAreFunWeb.RobotController do
  use RobotsAreFunWeb, :controller

  alias RobotsAreFun
  alias RobotsAreFun.Inventory.Load

  action_fallback RobotsAreFunWeb.FallbackController

  def index(conn, _params) do
    robots = RobotsAreFun.show_fleet()
    render(conn, :index, robots: robots)
  end

  def closest(conn, %{"loadId" => load_id, "x" => x, "y" => y}) do
    with {:ok, load} <- Load.new(load_id, x, y),
         {:ok, robot} <- RobotsAreFun.assign_robot_to_load(load) do
      render(conn, :show, robot: robot)
    end
  end
end
