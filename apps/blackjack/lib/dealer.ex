defmodule Blackjack.Dealer do
  @moduledoc """
  Documentation for `Blackjack`.
  """

  use GenServer

  # Client


  def connect() do
    GenServer.start_link(__MODULE__, [])
  end

  def hit(pid) do
    GenServer.call(pid, :hit)
  end

  def cards(pid) do
    GenServer.call(pid, :cards)
  end

  # Server (callbacks)
  defp deal() do
    [Blackjack.Deck.get(), Blackjack.Deck.get()]
  end

  @impl true
  def init(_opts) do
    {:ok, deal()}
  end

  @impl true
  def handle_call(:hit, _from, hand) do
    newHand = [Blackjack.Deck.get() | hand]
    if Blackjack.Hand.getValue(newHand) > 21 do
      Blackjack.Deck.put(newHand)
      {:reply, Blackjack.Hand.handState(newHand), []}
    else
      {:reply, Blackjack.Hand.handState(newHand), newHand}
    end
  end

  @impl true
  def handle_call(:cards, _from, hand), do: {:reply, Blackjack.Hand.handState(hand), hand}
end
