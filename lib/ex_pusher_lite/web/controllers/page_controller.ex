defmodule ExPusherLite.Web.PageController do
  use ExPusherLite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
