defmodule Blackjack.HandTest do
  use ExUnit.Case, async: true
  doctest Blackjack.Hand

  test "calculates hand value with simple hand" do
    assert Blackjack.Hand.getValue([{2, "Clubs"}, {9, "Spades"}, {3, "Diamonds"}]) == 14
  end

  test "calculates hand with one ace" do
    assert Blackjack.Hand.getValue([{2, "Clubs"}, {"Ace", "Spades"}, {3, "Diamonds"}]) == 16
  end

  test "calculates hand with one ace where higher value busts" do
    assert Blackjack.Hand.getValue([{2, "Clubs"}, {"Ace", "Spades"}, {"King", "Diamonds"}]) == 13
  end

  test "calculates hand with two aces where middle value is optimal" do
    assert Blackjack.Hand.getValue([{"Ace", "Clubs"}, {"Ace", "Spades"}, {8, "Diamonds"}]) == 20
  end

  test "returns valid hand string for a given hand" do
    result = "Your current hand is AC AS 8D, this is worth 20 points."
    assert Blackjack.Hand.handString([hand: [{"Ace", "Clubs"}, {"Ace", "Spades"}, {8, "Diamonds"}]]) == result
  end

  test "tells a player they have bust if they go over 21" do
    result = "Your current hand is 9C KS KD, this is worth 29 points. You have bust."
    assert Blackjack.Hand.handString([hand: [{9, "Clubs"}, {"King", "Spades"}, {"King", "Diamonds"}]]) == result
  end

  test "returns hand state for a given hand" do
    hand = [{"Ace", "Clubs"}, {"Ace", "Spades"}, {8, "Diamonds"}]
    assert Blackjack.Hand.handState(hand) == [hand: hand, value: 20]
  end
end
