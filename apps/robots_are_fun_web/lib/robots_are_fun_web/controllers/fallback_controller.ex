defmodule RobotsAreFunWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use RobotsAreFunWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: RobotsAreFunWeb.ErrorHTML, json: RobotsAreFunWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, error}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: RobotsAreFunWeb.ErrorJSON)
    |> render("error.json", error: error)
  end
end
