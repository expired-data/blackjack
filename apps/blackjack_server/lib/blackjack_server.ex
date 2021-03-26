defmodule BlackjackServer do
  require Logger


  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(BlackjackServer.TaskSupervisor, fn -> handle_connection(client); serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp handle_connection(socket) do
    {:ok, pid} = Blackjack.Dealer.connect()
    Process.put(:dealer, pid)
    write_line(socket, {:ok, Blackjack.Dealer.cards(pid) |> Blackjack.Hand.handString})
  end

  defp serve(socket) do
    msg = with {:ok, data} <- read_line(socket),
        {:ok, command} <- BlackjackServer.Command.parse(data),
        do: BlackjackServer.Command.run(command)

    write_line(socket, msg)

    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, msg}) do
    :gen_tcp.send(socket, msg)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # Known error; write to the client
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # The connection was closed, exit politely
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    # Unknown error; write to the client and exit
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
