defmodule Blackjack.Hand do
  defp cardValue({value, _suit }) when is_number(value), do: value
  defp cardValue({"Ace", _suit}), do: 1
  defp cardValue({value, _suit}) when is_bitstring(value), do: 10

  def getValue(hand) do
    Enum.reduce(hand, 0, fn el, acc -> acc + cardValue(el) end)
  end

  defp suitUnicode({_value, suit}) do
    case suit do
      "Spades" -> "♠"
      "Hearts" -> "♥"
      "Diamonds" -> "♦"
      "Clubs" -> "♣"
    end
  end

  defp cardName({value, _suit}) when is_number(value), do: value
  defp cardName({value, _suit}) when is_bitstring(value), do: String.at(value, 0)

  defp cardUnicode(card) do
    "#{cardName(card)}#{suitUnicode(card)}"
  end

  def getUnicode(hand) do
    Enum.reduce(hand, "", fn el, acc -> "#{acc} #{cardUnicode(el)}" end)
  end

  def handString(hand) do
    "Your current hand is#{getUnicode(hand)}, this is worth #{getValue(hand)} points."
  end

  def handState(hand) do
    [hand: hand, value: getValue(hand)]
  end
end
