defmodule TwitterWeb.PageController do
  use TwitterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def home(conn, %{"uname"=>uname}) do
    render conn, "home.html", uname: uname
  end

end
