defmodule BlackjackServer.Command do
  def parse(line) do
    case String.split(line) do
      ["hit"] -> {:ok, {:hit}}
      ["cards"] -> {:ok, {:cards}}
      _ -> {:error, :unknown_command}
    end
  end

  def run({:hit}) do
    {:ok, Blackjack.Dealer.hit(Process.get(:dealer))}
  end

  def run({:cards}) do
    {:ok, Blackjack.Dealer.cards(Process.get(:dealer))}
  end
end
