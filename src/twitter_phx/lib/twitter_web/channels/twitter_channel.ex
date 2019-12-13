defmodule TwitterWeb.TwitterChannel do
  use TwitterWeb, :channel

  def join("twitter:lobby", _payload, socket) do
    {:ok, %{channel: "twitter:lobby"}, socket}
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

  #similarly for tweet, update timeline, retweet, query tweets
  #this module is intended to replace the Twitter.Api module

end
