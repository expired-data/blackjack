defmodule Blackjack.Supervisor do
  use Supervisor

  @doc """
  Starts the Blackjack supervisor
  """
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok,opts)
  end

  @impl true
  def init(:ok) do
    children = [
      Blackjack.Deck,
      Blackjack.Stats
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
