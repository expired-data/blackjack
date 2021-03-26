defmodule BlackjackServer.Command do
  def parse(line) do
    case String.split(line) do
      ["hit"] -> {:ok, {:hit}}
      ["cards"] -> {:ok, {:cards}}
      ["reset"] -> {:ok, {:reset}}
      ["stats"] -> {:ok, {:stats}}
      _ -> {:error, :unknown_command}
    end
  end

  def run({:hit}) do
    {:ok, Blackjack.Dealer.hit(Process.get(:dealer))}
  end

  def run({:cards}) do
    {:ok, Blackjack.Dealer.cards(Process.get(:dealer))}
  end

  def run({:reset}) do
    {:ok, Blackjack.Dealer.reset(Process.get(:dealer))}
  end

  def run({:stats}) do
    {:ok, Blackjack.Dealer.stats(Process.get(:Dealer))}
  end
end
