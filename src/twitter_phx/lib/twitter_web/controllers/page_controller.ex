defmodule TwitterWeb.PageController do
  use TwitterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
"""
  def home(conn, %{"username"=>username}) do
    render conn, "home.html", username: "naman"
  end
  """

end
