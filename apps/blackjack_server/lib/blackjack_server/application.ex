defmodule BlackjackServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    tcpPort = String.to_integer(System.get_env("TCP_PORT") || "4040")
    httpPort = String.to_integer(System.get_env("HTTP_PORT") || "4041")
    ip = List.to_tuple(for i <- String.split(System.get_env("HOST_IP") || "127.0.0.1", "."), do: elem(Integer.parse(i),0))

    children = [
      {Task.Supervisor, name: BlackjackServer.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> BlackjackServer.accept(tcpPort) end}, restart: :permanent),
      {Plug.Cowboy, scheme: :http, plug: BlackjackServer.Plug, options: [port: httpPort, ip: ip]},
      BlackjackServer.PIDAgent
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlackjackServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
