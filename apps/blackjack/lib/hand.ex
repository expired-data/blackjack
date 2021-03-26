defmodule Blackjack.Hand do
  defp cardValue({value, _suit }) when is_number(value), do: [value]
  defp cardValue({"Ace", _suit}), do: [1, 11]
  defp cardValue({value, _suit}) when is_bitstring(value), do: [10]

  @doc """
  Gets the value for a hand, calculating all possible values given Aces and returning the most optimal:
  returns The highest value that would still be in play or the lowest bust value
  """
  def getValue(hand) do
    candidateValues = Enum.reduce(hand, [0], fn el, acc -> for i <- acc, j <- cardValue(el), do: i+j end)
    case Enum.filter(candidateValues, & &1<=21) do
      [] -> Enum.min(candidateValues)
      vals -> Enum.max(vals)
    end
  end

  defp suitUnicode({_value, suit}) do
    case suit do
      # Telnet on windows isn't happy with these characters instead use single char abbreviation
      "Spades" -> "S" #"♠"
      "Hearts" -> "H" #"♥"
      "Diamonds" -> "D" #"♦"
      "Clubs" -> "C" #"♣"
    end
  end

  defp cardName({value, _suit}) when is_number(value), do: value
  defp cardName({value, _suit}) when is_bitstring(value), do: String.at(value, 0)

  defp cardUnicode(card) do
    "#{cardName(card)}#{suitUnicode(card)}"
  end

  defp getUnicode(hand) do
    Enum.reduce(hand, "", fn el, acc -> "#{acc} #{cardUnicode(el)}" end)
  end

  @doc """
  Gets a formatted string for the given hand showing the cards and values

  ## Examples

      iex> Blackjack.Hand.handString([hand: [{"Ace", "Spades"}, {9, "Clubs"}]])
      "Your current hand is AS 9C, this is worth 20 points."

  """
  def handString(handState) do
    "Your current hand is#{getUnicode(handState[:hand])}, this is worth #{getValue(handState[:hand])} points."
  end

  @doc """
  Takes a hand and returns a tuple with the hand and the value for that hand

  ## Examples

      iex> Blackjack.Hand.handState([{"Ace", "Spades"}, {9, "Clubs"}])
      [hand: [{"Ace", "Spades"}, {9, "Clubs"}], value: 20]

  """
  def handState(hand) do
    [hand: hand, value: getValue(hand)]
  end
end
