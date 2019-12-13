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
    push(socket, "signup_result", %{res: res, user: uname})
    {:noreply, socket}
  end

  def handle_int("signin", _payload, _socket) do
    #use this to handle authirization
  end

  #similarly for tweet, update timeline, retweet, query tweets
  #this module is intended to replace the Twitter.Api module

end
