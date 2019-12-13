defmodule Twitter.Relay.Public do

  def signup(u_name_atom) do
    GenServer.call(:relay, {:signup, u_name_atom})
  end

  #for login
  def user?(u_name_atom) do
    GenServer.call(:relay, {:user?, u_name_atom})
  end

end
