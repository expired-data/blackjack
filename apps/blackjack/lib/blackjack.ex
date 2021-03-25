defmodule Blackjack do
  use Application

  @impl true
  def start(_type, _args) do
    Blackjack.Supervisor.start_link([]);
  end
end
