defmodule RobotsAreFun.Fleet do
  @moduledoc """
  Fetch the fleet of default robots from SVT endpoint.
  """
  require Logger

  @fleet_endpoint "https://60c8ed887dafc90017ffbd56.mockapi.io/robots"

  def get_fleet() do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(@fleet_endpoint),
         {:ok, fleet} <- Jason.decode(body)
    do
      fleet
    else
      error ->
        Logger.error(error)
        raise "Error fetching robot fleet!"
    end
  end
end
