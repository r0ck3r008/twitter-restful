defmodule Twitter.Relay.Helper do

  require Logger

  def parse_regex(nil, _, list), do: list
  def parse_regex(msg, regex, list) do
    match=Regex.run(regex, msg)
    case match do
      nil->
        parse_regex(nil, regex, list)
      _->
        match=Enum.at(match, 1)
        msg=String.replace(msg, match, "")
        parse_regex(msg, regex, list++[String.to_atom(match)])
    end
  end

  def parse_tweet(msg) do
    #look for hashtags and mentions
    [parse_regex(msg, ~r/#(\w+)/, [])]++[parse_regex(msg, ~r/@(\w+)/, [])]
  end

  def handle_tweet(from_atom, msg, tweet_info) do
    tags=Enum.at(tweet_info, 0)
    mentions=Enum.at(tweet_info, 1)
    followers=Enum.at(tweet_info, 2)
    fwd_tweets(from_atom, Enum.uniq(followers++mentions), msg, :users)
    fwd_tweet(from_atom, tags, msg, :tags)
  end

  #fwd to users(followers/mentions)
  def fwd_tweets(from_atom, u_names, msg, :users) do
    for u_name<-u_names do
      send(u_name, {:new_tweet, from_atom, msg})
    end
  end
  #fwd to hashtags
  def fwd_tweet(from_atom, tags, msg, :tags) do
    users=Agent.get(:u_agnt, fn(state)->state end)
    for tag<-tags do
      if tag in users do
        send(tag, {:new_tweet_tag, msg})
      else
        #make new tag
        make_new_tag(tag, from_atom)
        send(tag, {:new_tweet_tag, msg})
      end
    end
  end

  def make_new_tag(tag, from_atom) do
    #form the user
    Twitter.User.start_link(tag, :tag)
    Logger.debug("Created new hash, #{inspect tag}")
    Agent.update(:u_agnt, &(&1++[tag]))
    Twitter.User.Public.follow(from_atom, tag)
  end

end
