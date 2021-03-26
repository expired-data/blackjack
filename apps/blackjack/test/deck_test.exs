defmodule Blackjack.DeckTest do
  use ExUnit.Case
  doctest Blackjack.Deck

  test "can get a card from the deck" do
    {value, suit} = Blackjack.Deck.get()
    assert Enum.member?(Enum.to_list(2..10) ++ ["Jack", "Queen", "King", "Ace"], value)
    assert Enum.member?(["Spades", "Hearts", "Clubs", "Diamonds"], suit)
  end

  test "cards cycle through deck" do
    card = Blackjack.Deck.get()
    Blackjack.Deck.put([card])
    assert Agent.get(Blackjack.Deck, fn deck -> List.last(deck) end) == card
  end
end
