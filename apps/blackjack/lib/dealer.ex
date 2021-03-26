defmodule Blackjack.Dealer do
  @moduledoc """
  Documentation for `Blackjack`.
  """

  use GenServer

  # Client

  @doc """
  Connect to the GenServer

  Returns `{:ok, pid}`.
  """
  def connect() do
    GenServer.start_link(__MODULE__, [])
  end

  @doc """
  Ask the dealer to deal you another card

  Does not deal you another card if you are already bust
  """
  def hit(pid) do
    GenServer.call(pid, :hit)
  end

  @doc """
  Gives the current cards dealt to the player and their best value
  """
  def cards(pid) do
    GenServer.call(pid, :cards)
  end

  @doc """
  Resets play dealing a new hand and recording the score of the current hand as the current value if sticking or 0 if bust
  """
  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  @doc """
  Gets the current stats of the game session
  """
  def stats(pid) do
    GenServer.call(pid, :stats)
  end

  # Server (callbacks)

  defp deal() do
    [Blackjack.Deck.get(), Blackjack.Deck.get()]
  end

  @impl true
  def init(_opts) do
    Blackjack.Stats.register(self())
    {:ok, deal()}
  end

  @impl true
  def handle_call(:hit, _from, hand) do
    if Blackjack.Hand.getValue(hand) > 21 do
      {:reply, Blackjack.Hand.handState(hand), hand}
    else
      newHand = [Blackjack.Deck.get() | hand]
      {:reply, Blackjack.Hand.handState(newHand), newHand}
    end
  end

  @impl true
  def handle_call(:cards, _from, hand), do: {:reply, Blackjack.Hand.handState(hand), hand}

  @impl true
  def handle_call(:reset, _from, hand) do
    value = Blackjack.Hand.getValue(hand)
    Blackjack.Stats.record_score(if(value > 21, do: 0, else: value), self())
    Blackjack.Deck.put(hand)
    newHand = deal()
    {:reply, Blackjack.Hand.handState(newHand), newHand}
  end

  @impl true
  def handle_call(:stats, _from, hand) do
    {:reply, Blackjack.Stats.get(self()), hand}
  end
end
