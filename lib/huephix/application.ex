defmodule Huephix.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # # Starts the bridges agent
      supervisor(Huephix.Bridges, []),
      # # Start the Boot sequence for the Hue bridge stuff
      worker(Huephix.BootSeq, [], restart: :temporary),
      # Start the Ecto repository
      supervisor(Huephix.Repo, []),
      # Start the endpoint when the application starts
      supervisor(HuephixWeb.Endpoint, []),
      # Start your own worker by calling: Huephix.Worker.start_link(arg1, arg2, arg3)
      # worker(Huephix.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Huephix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HuephixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
