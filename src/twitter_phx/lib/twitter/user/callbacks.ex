defmodule Twitter.User do

  use GenServer
  require Logger
  alias Twitter.User.Helper

  def start_link(u_name_atom) do
    Agent.start_link(fn-> [u_name_atom] end, name: Helper.get_agnt(u_name_atom, :followers))
    Agent.start_link(fn-> [] end, name: Helper.get_agnt(u_name_atom, :follow_to))
    Agent.start_link(fn-> %{} end, name: Helper.get_agnt(u_name_atom, :tweets))
    GenServer.start_link(__MODULE__, u_name_atom, name: u_name_atom)
  end
  def start_link(tag_atom, :tag) do
    Agent.start_link(fn-> [] end, name: Helper.get_agnt(tag_atom, :followers))
    Agent.start_link(fn-> %{} end, name: Helper.get_agnt(tag_atom, :tweets))
    GenServer.start_link(__MODULE__, tag_atom, name: tag_atom)
  end

  @impl true
  def init(u_name_atom) do
    {:ok, u_name_atom}
  end

  @impl true
  def handle_cast({:follow, to_atom}, u_name_atom) do
    Twitter.Relay.Public.follow(u_name_atom, to_atom)
    Agent.update(Helper.get_agnt(u_name_atom, :follow_to), &(&1++[to_atom]))
    {:noreply, u_name_atom}
  end

  @impl true
  def handle_cast({:follower, from_atom}, u_name_atom) do
    Agent.update(Helper.get_agnt(u_name_atom, :followers), &(&1++[from_atom]))
    Logger.debug("Follow success from #{inspect from_atom}")
    {:noreply, u_name_atom}
  end

  @impl true
  def handle_cast({:tweet, msg, :noparse}, u_name_atom) do
    tweets_l=Agent.get(Helper.get_agnt(u_name_atom, :tweets), &Map.get(&1, u_name_atom))
    case tweets_l do
      nil
      ->
        Agent.update(Helper.get_agnt(u_name_atom, :tweets), &Map.put(&1, u_name_atom, [msg]))
      _
      ->
        Agent.update(Helper.get_agnt(u_name_atom, :tweets), &Map.put(&1, u_name_atom, tweets_l++[msg]))
    end
    followers=Agent.get(Helper.get_agnt(u_name_atom, :followers), fn(state)-> state end)
    Twitter.Relay.Public.relay_tweet(u_name_atom, msg, followers, :noparse)
    {:noreply, u_name_atom}
  end
  @impl true
  def handle_cast({:tweet, msg}, u_name_atom) do
    tweets_l=Agent.get(Helper.get_agnt(u_name_atom, :tweets), &Map.get(&1, u_name_atom))
    case tweets_l do
      nil
      ->
        Agent.update(Helper.get_agnt(u_name_atom, :tweets), &Map.put(&1, u_name_atom, [msg]))
      _
      ->
        Agent.update(Helper.get_agnt(u_name_atom, :tweets), &Map.put(&1, u_name_atom, tweets_l++[msg]))
    end
    followers=Agent.get(Helper.get_agnt(u_name_atom, :followers), fn(state)->state end)
    Twitter.Relay.Public.relay_tweet(u_name_atom, msg, followers)
    {:noreply, u_name_atom}
  end

  @impl true
  def handle_info({:new_tweet, from_atom, msg}, u_name_atom) do
    tweet_l=Agent.get(Helper.get_agnt(u_name_atom, :tweets), &Map.get(&1, from_atom))
    case tweet_l do
      nil
      ->
        Agent.update(Helper.get_agnt(u_name_atom, :tweets), &Map.put(&1, from_atom, [msg]))
      _
      ->
        Agent.update(Helper.get_agnt(u_name_atom, :tweets), &Map.put(&1, from_atom, tweet_l++[msg]))
    end
    {:noreply, u_name_atom}
  end

  @impl true
  def handle_info({:new_tweet_tag, msg}, u_name_atom) do
    Twitter.User.Public.tweet(u_name_atom, msg, :noparse)
    {:noreply, u_name_atom}
  end

  @impl true
  def handle_call(:fetch_tweets, _from, u_name_atom) do
    state=Agent.get(Helper.get_agnt(u_name_atom, :tweets), fn(state)->state end)
    tweets=for {tweeter, tweet_list}<-state do
      for tweet<-tweet_list, do: %{tweeter: tweeter, tweet: tweet}
    end
    {:reply, Enum.uniq(List.flatten(tweets)), u_name_atom}
  end

  @impl true
  def handle_call(:fetch_mentions, _from, u_name_atom) do
    tweets=Agent.get(Helper.get_agnt(u_name_atom, :tweets), fn(state)-> state end)
    mentioned_l=Helper.get_mentions(u_name_atom, tweets)
    {:reply, mentioned_l, u_name_atom}
  end

end
