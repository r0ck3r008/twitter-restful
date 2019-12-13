defmodule Twitter.Relay do

  use GenServer
  require Logger

  def start_link([]) do
    Agent.start_link(fn-> [] end, name: :u_agnt)
    Agent.start_link(fn-> {} end, name: :fol_agnt)
    GenServer.start_link(__MODULE__, :ok, name: :relay)
  end

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  ###########management related
  @impl true
  def handle_call({:signup, u_name_atom}, _from, _) do
    state=Agent.get(:u_agnt, fn(state)->state end)
    if u_name_atom in state do
      {:reply, false, []}
    else
      Twitter.User.start_link(u_name_atom)
      Agent.update(:u_agnt, &(&1++[u_name_atom]))
      {:reply, true, []}
    end
  end

  @impl true
  def handle_call({:user?, u_name_atom}, _from, _) do
    state=Agent.get(:u_agnt, fn(state)-> state end)
    if u_name_atom in state do
      {:reply, :ok, []}
    else
      {:reply, :deny, []}
    end
  end
  ############management related
  
  ###########follow related
  @impl true
  def handle_cast({:follow, from_atom, to_atom}, _) do
    Twitter.User.Public.followed_notif(to_atom, from_atom)
    {:noreply, []}
  end
  ############follow related

end
