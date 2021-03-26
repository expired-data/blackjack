defmodule Blackjack.Stats do
  use Agent

  defp pid_to_string(pid), do: "#{inspect pid}" # little bit hacky

  @doc """
  Starts the stats map Agent
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Registers a new dealer session for stat tracking
  """
  def register(pid) do
    Agent.update(__MODULE__, fn stats -> Map.put(stats, pid_to_string(pid), [games: 0, total: 0, busts: 0, average: 0]) end)
  end

  defp updateStats([games: games,total: total,busts: busts, average: _average], score) do
    [games: games + 1, total: total + score, busts: busts + (if score === 0, do: 1, else: 0), average: (total + score) / (games + 1)]
  end

  @doc """
  Records a game completion for a given dealer
  """
  def record_score(score, pid) do
    Agent.get_and_update(__MODULE__, fn stats -> stats[pid_to_string(pid)] |> updateStats(score) |> (& {&1, Map.put(stats, pid_to_string(pid), &1)}).() end)
  end

  @doc """
  Gets the stats for a given dealer
  """
  def get(pid) do
    Agent.get(__MODULE__, fn stats -> stats[pid_to_string(pid)] end)
  end

  @doc """
  Formats stats to a nice string
  """
  def statsString(stats) do
    "You have played #{stats[:games]} games, busting #{stats[:busts]} times, with an average score of #{stats[:average]}"
  end
end
