defmodule RobotsAreFunWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RobotsAreFunWeb.Telemetry,
      # Start the Endpoint (http/https)
      RobotsAreFunWeb.Endpoint
      # Start a worker by calling: RobotsAreFunWeb.Worker.start_link(arg)
      # {RobotsAreFunWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RobotsAreFunWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RobotsAreFunWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
