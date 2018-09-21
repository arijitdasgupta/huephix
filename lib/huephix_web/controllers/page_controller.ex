defmodule HuephixWeb.PageController do
  use HuephixWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
