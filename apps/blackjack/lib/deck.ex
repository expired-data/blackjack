defmodule Blackjack.Deck do
  use Agent

  defp getCards() do
    values = Enum.to_list(2..10) ++ ["Jack", "Queen", "King", "Ace"]
    suits = ["Spades", "Hearts", "Clubs", "Diamonds"]
    for i <- values, j <- suits, do: {i, j}
  end

  defp shuffleRecursive([h | _t], 1, result), do: [h | result]

  defp shuffleRecursive(deck, n, result) do
    swapIdx = Enum.random(0..n)
    cur = Enum.at(deck, n)
    shuffled = Enum.at(deck, swapIdx)
    shuffleRecursive(List.replace_at(deck, swapIdx, cur), n - 1, [shuffled | result])
  end

  defp shuffleDeck(deck), do: shuffleRecursive(deck, length(deck) - 1, [])

  @doc """
  Starts a new deck
  """
  def start_link(_opts) do
    Agent.start_link(fn -> shuffleDeck(getCards()) end, name: __MODULE__)
  end

  defp getCard([hd | tl]), do: {hd, tl}

  defp getCard([]) do
    raise("No cards left in the deck")
  end

  @doc """
  Gets a card from the deck
  """
  def get() do
    Agent.get_and_update(__MODULE__, &(getCard/1))
  end

  @doc """
  Puts a hand of cards back into the deck
  """
  def put(cards) do
    Agent.update(__MODULE__, fn deck -> deck ++ cards end)
  end
end
