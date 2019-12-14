defmodule TwitterWeb.TwitterChannel do
  use TwitterWeb, :channel

  def join("twitter:room", _payload, socket) do
    {:ok, %{channel: "twitter:room"}, socket}
  end

  def handle_in("signup", payload, socket) do
    #use this to create a new Twitter.User gensrv
    uname=payload["uname"]
    passwd=payload["passwd"]
    u_name_atom=String.to_atom(uname)
    res=Twitter.Relay.Public.signup(u_name_atom)
    if res==true do
      Twitter.Accounts.changeset(%Twitter.Accounts{}, %{uname: uname, passwd: passwd})
      |> Twitter.Repo.insert!
    end
    push(socket, "signup_result", %{res: res, uname: uname})
    {:noreply, socket}
  end

  def handle_in("signin", payload, socket) do
    #use this to handle authirization
    uname=payload["uname"]
    passwd=payload["passwd"]
    passwd_hash=:crypto.hash(:sha256, passwd)
                |> Base.encode16

    res=Twitter.Repo.get_by(Twitter.Accounts, uname: uname)
        |> IO.inspect
    if res != nil do
      hash=res.passwd_hash
      if hash==passwd_hash do
        IO.puts "Login success"
        push(socket, "signin_result", %{res: true, uname: uname})
      end
    else
      IO.puts "Login fail"
      push(socket, "signin_result", %{res: false, uname: uname})
    end

    {:noreply, socket}
  end

  def handle_in("follow", payload, socket) do
    to_follow=payload["to_follow"]
    uname=payload["uname"]
    Twitter.User.Public.follow(String.to_atom(uname), String.to_atom(to_follow))
    {:noreply, socket}
  end

  def handle_in("update_feed", payload, socket) do
    uname=payload["uname"]
    tweets=Twitter.User.Public.fetch_tweets(String.to_atom(uname))
           |>IO.inspect
    push(socket, "update_feed", %{tweets: tweets})
    {:noreply, socket}
  end

  def handle_in("tweet", payload, socket) do
    tweeter=payload["uname"]
    tweet=payload["tweet"]
    Twitter.User.Public.tweet(String.to_atom(tweeter), tweet)
    push(socket, "tweet_status", %{stat: 1})
    {:noreply, socket}
  end

  def handle_in("get_hash_tag", payload, socket) do
    tag=payload["hashtag"]
    tweets=Twitter.User.Public.fetch_tweets(String.to_atom(tag))
    push(socket, "get_hash_tag", %{tweets: tweets})
    {:noreply, socket}
  end

  def handle_in("get_mentions", payload, socket) do
    uname=payload["uname"]
    tweets=Twitter.User.Public.fetch_mentions(String.to_atom(uname))
           |>IO.inspect
    push(socket, "get_mentions", %{tweets: tweets})
    {:noreply, socket}
  end

  def handle_in("retweet", payload, socket) do
    tweeter=payload["uname"]
    tweet=payload["tweet"]
    org=payload["org"]
    Twitter.User.Public.retweet(String.to_atom(tweeter), String.to_atom(org), tweet)
    push(socket, "tweet_status", %{stat: 1})
    {:noreply, socket}
  end

end
