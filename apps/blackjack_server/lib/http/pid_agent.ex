defmodule BlackjackServer.PIDAgent do
  use Agent
   @doc """
  Starts a new deck
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Gets a card from the deck
  """
  def get(sid) do
    Agent.get(__MODULE__, fn map -> map[sid] end)
  end

  @doc """
  Puts a hand of cards back into the deck
  """
  def put(sid, pid) do
    Agent.update(__MODULE__, fn map -> Map.put(map, sid, pid) end)
  end
end
