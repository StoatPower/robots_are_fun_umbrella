defmodule RobotsAreFun.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: RobotsAreFun.PubSub}
      # Start a worker by calling: RobotsAreFun.Worker.start_link(arg)
      # {RobotsAreFun.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: RobotsAreFun.Supervisor)
  end
end
