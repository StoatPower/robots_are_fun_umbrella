defmodule RobotsAreFunWeb.RobotControllerTest do
  use RobotsAreFunWeb.ConnCase

  import RobotsAreFun.FleetFixtures

  alias RobotsAreFun.Fleet.Robot

  @create_attrs %{
    battery_level: 42,
    id: "some id",
    x: 42,
    y: 42
  }
  @update_attrs %{
    battery_level: 43,
    id: "some updated id",
    x: 43,
    y: 43
  }
  @invalid_attrs %{battery_level: nil, id: nil, x: nil, y: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all robots", %{conn: conn} do
      conn = get(conn, ~p"/api/robots")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create robot" do
    test "renders robot when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/robots", robot: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/robots/#{id}")

      assert %{
               "id" => ^id,
               "battery_level" => 42,
               "id" => "some id",
               "x" => 42,
               "y" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/robots", robot: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update robot" do
    setup [:create_robot]

    test "renders robot when data is valid", %{conn: conn, robot: %Robot{id: id} = robot} do
      conn = put(conn, ~p"/api/robots/#{robot}", robot: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/robots/#{id}")

      assert %{
               "id" => ^id,
               "battery_level" => 43,
               "id" => "some updated id",
               "x" => 43,
               "y" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, robot: robot} do
      conn = put(conn, ~p"/api/robots/#{robot}", robot: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete robot" do
    setup [:create_robot]

    test "deletes chosen robot", %{conn: conn, robot: robot} do
      conn = delete(conn, ~p"/api/robots/#{robot}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/robots/#{robot}")
      end
    end
  end

  defp create_robot(_) do
    robot = robot_fixture()
    %{robot: robot}
  end
end
