defmodule Twitter.User.Public do

  def follow(of, to_atom) do
    GenServer.cast(of, {:follow, to_atom})
  end

  def followed_notif(of, from_atom) do
    GenServer.cast(of, {:follower, from_atom})
  end

end
