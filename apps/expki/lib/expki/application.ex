defmodule Expki.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Expki.Repo,
      {DNSCluster, query: Application.get_env(:expki, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Expki.PubSub}
      # Start a worker by calling: Expki.Worker.start_link(arg)
      # {Expki.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Expki.Supervisor)
  end
end
