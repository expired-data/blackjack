defmodule BlackjackServer.Command do
  def parse(line) do
    case String.split(line) do
      ["hit"] -> {:ok, {:hit}}
      ["cards"] -> {:ok, {:cards}}
      ["stick"] -> {:ok, {:reset}}
      ["reset"] -> {:ok, {:reset}}
      ["help"] -> {:ok, {:help}}
      ["stats"] -> {:ok, {:stats}}
      _ -> {:error, :unknown_command}
    end
  end

  def run({:hit}) do
    {:ok, Blackjack.Dealer.hit(Process.get(:dealer)) |> Blackjack.Hand.handString}
  end

  def run({:cards}) do
    {:ok, Blackjack.Dealer.cards(Process.get(:dealer)) |> Blackjack.Hand.handString}
  end

  def run({:reset}) do
    {:ok, Blackjack.Dealer.reset(Process.get(:dealer)) |> Blackjack.Hand.handString}
  end

  def run({:stats}) do
    {:ok, Blackjack.Dealer.stats(Process.get(:dealer)) |> Blackjack.Stats.statsString}
  end

  def run({:help}) do
    {:ok, "Send options to play blackjack\r\n\"cards\"\twill show you your current hand\r\n\"hit\"\twill deal you another card\r\n\"stick\"\twill complete the hand\r\n\"reset\"\twill also complete the hand\r\n\"stats\"\twill show stats for the current session"}
  end
end
