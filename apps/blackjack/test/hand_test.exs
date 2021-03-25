defmodule Blackjack.HandTest do
  use ExUnit.Case, async: true

  test "can hit a card to hand" do
    {:ok, hand} = Blackjack.Hand.connect()
    assert (tuple_size hand) == 2
  end
end
