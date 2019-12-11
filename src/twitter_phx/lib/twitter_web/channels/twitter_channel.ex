
defmodule TwitterWeb.TwitterChannel do
  use TwitterWeb, :channel

  def join("twitter:lobby", payload, socket) do
#    if authorized?(payload) do
     {:ok, socket}
#    else
#      {:error, %{reason: "unauthorized"}}
#    end
  end

  def handle_in("signup", payload, socket) do
    #use this ti create a new Twitter.User gensrv
  end

  def handle_int("signin", payload, socket) do
    #use this to handle authirization
  end

  #similarly for tweet, update timeline, retweet, query tweets
  #this module is intended to replace the Twitter.Api module

  """
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (twitter:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
  """
end
