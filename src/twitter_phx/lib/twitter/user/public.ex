defmodule Twitter.User.Public do

  def follow(of, to_atom) do
    GenServer.cast(of, {:follow, to_atom})
  end

  def followed_notif(of, from_atom) do
    GenServer.cast(of, {:follower, from_atom})
  end

  def tweet(of, msg, :noparse) do
    GenServer.cast(of, {:tweet, msg, :noparse})
  end
  def tweet(of, msg) do
    GenServer.cast(of, {:tweet, msg})
  end

  def fetch_tweets(of) do
    GenServer.call(of, :fetch_tweets)
  end

  def fetch_mentions(of) do
    GenServer.call(of, :fetch_mentions)
  end

  def retweet(of, from, tweet) do
    Twitter.Relay.Public.retweet(of, from, tweet)
    GenServer.cast(of, {:tweet, "Retweet: "<>tweet, :noparse})
  end

  def retweet_notif(of, tweet, from) do
    GenServer.cast(of, {:retweet_notif, from, tweet})
  end

end
