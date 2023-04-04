defmodule RobotsAreFunWeb.RobotController do
  use RobotsAreFunWeb, :controller

  alias RobotsAreFun
  alias RobotsAreFun.Fleet.Robot

  action_fallback RobotsAreFunWeb.FallbackController

  def index(conn, _params) do
    robots = RobotsAreFun.show_fleet()
    render(conn, :index, robots: robots)
  end
end
