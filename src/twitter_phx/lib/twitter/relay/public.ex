defmodule Twitter.Relay.Public do

  def signup(u_name_atom) do
    GenServer.call(:relay, {:signup, u_name_atom})
  end

  def fetch_users do
    GenServer.call(:relay, :fetch_users)
  end

  #for login
  def user?(u_name_atom) do
    GenServer.call(:relay, {:user?, u_name_atom})
  end

  def follow(from_atom, to_atom) do
    GenServer.cast(:relay, {:follow, from_atom, to_atom})
  end

  def relay_tweet(from_atom, msg, followers, :noparse) do
    GenServer.cast(:relay, {:relay_tweet, from_atom, msg, [[], []]++[followers]})
  end
  def relay_tweet(from_atom, msg, followers) do
    tweet_info=Twitter.Relay.Helper.parse_tweet(msg)
    GenServer.cast(:relay, {:relay_tweet, from_atom, msg, tweet_info++[followers]})
  end

  def retweet(of, from, tweet) do
    GenServer.cast(:relay, {:retweet, of, from, tweet})
  end

end
