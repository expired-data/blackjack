defmodule Blackjack.DealerTest do
  use ExUnit.Case, async: true
  doctest Blackjack.Dealer

  test "can start a game with the dealer" do
    {:ok, pid} = Blackjack.Dealer.connect()
    assert length(Blackjack.Dealer.cards(pid)[:hand]) == 2
  end

  test "can ask the dealer to hit" do
    {:ok, pid} = Blackjack.Dealer.connect()
    assert length(Blackjack.Dealer.hit(pid)[:hand]) == 3
  end

  defp hitUntilBust(pid) do
    if Blackjack.Hand.getValue(Blackjack.Dealer.hit(pid)[:hand]) <= 21, do: hitUntilBust(pid)
  end

  test "when bust the dealer will no longer hit" do
    {:ok, pid} = Blackjack.Dealer.connect()
    hitUntilBust(pid)
    assert Blackjack.Dealer.hit(pid) == Blackjack.Dealer.hit(pid)
  end

  test "dealer returns current cards when calling cards" do
    {:ok, pid} = Blackjack.Dealer.connect()
    assert Blackjack.Dealer.hit(pid) == Blackjack.Dealer.cards(pid)
  end

  test "dealer resets game when calling reset" do
    {:ok, pid} = Blackjack.Dealer.connect()
    Blackjack.Dealer.hit(pid)
    assert length(Blackjack.Dealer.reset(pid)[:hand]) == 2
  end

  test "dealer returns stats for current session" do
    {:ok, pid} = Blackjack.Dealer.connect()
    assert Blackjack.Dealer.stats(pid) ==  [games: 0, total: 0, busts: 0, average: 0]
    value = Blackjack.Dealer.cards(pid)[:value]
    Blackjack.Dealer.reset(pid)
    assert Blackjack.Dealer.stats(pid) == [games: 1, total: value, busts: 0, average: value]
  end
end
