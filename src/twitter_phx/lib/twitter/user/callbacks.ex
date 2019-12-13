defmodule Twitter.User do

  use GenServer
  require Logger

  def start_link(u_name_atom) do
    Agent.start_link(fn-> [] end, name: :followers)
    Agent.start_link(fn-> [] end, name: :follow_to)
    GenServer.start_link(__MODULE__, u_name_atom, name: u_name_atom)
  end

  @impl true
  def init(u_name_atom) do
    {:ok, u_name_atom}
  end

  @impl true
  def handle_cast({:follow, to_atom}, u_name_atom) do
    Twitter.Relay.Public.follow(u_name_atom, to_atom)
    Agent.update(:follow_to, &(&1++[to_atom]))
    {:noreply, u_name_atom}
  end

  @impl true
  def handle_cast({:follower, from_atom}, u_name_atom) do
    Agent.update(:followers, &(&1++[from_atom]))
    Logger.debug("Follow success from #{inspect from_atom}")
    {:noreply, u_name_atom}
  end

end
