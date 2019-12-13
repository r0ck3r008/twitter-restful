defmodule Twitter.User do

  def start_link(u_name_atom) do
    GenServer.start_link(__MODULE__, :ok, name: u_name_atom)
  end

  @impl true
  def init(:ok) do
    {:ok, []}
  end

end
