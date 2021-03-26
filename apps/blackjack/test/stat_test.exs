defmodule Blackjack.StatTest do
  use ExUnit.Case, async: true
  doctest Blackjack.Hand

  test "can register a new stat session" do
    Blackjack.Stats.register("test1")
    assert Blackjack.Stats.get("test1") == [games: 0, total: 0, busts: 0, average: 0]
  end

  test "can update stats with a new score" do
    Blackjack.Stats.register("test2")
    Blackjack.Stats.record_score(21, "test2")
    assert Blackjack.Stats.get("test2") == [games: 1, total: 21, busts: 0, average: 21]
  end

  test "updating with score of 0 counts as bust" do
    Blackjack.Stats.register("test3")
    Blackjack.Stats.record_score(0, "test3")
    assert Blackjack.Stats.get("test3") == [games: 1, total: 0, busts: 1, average: 0]
  end

  test "formats a stats string" do
    assert Blackjack.Stats.statsString([games: 2, total: 21, busts: 1, average: 21]) == "You have played #{2} games, busting #{1} times, with an average score of #{21}"
  end
end
