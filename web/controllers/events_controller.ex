defmodule ExPusherLite.EventsController do
  use ExPusherLite.Web, :controller

  def create(conn, params) do
    data = %{"name" => params["name"], "message" => params["message"]}
    ExPusherLite.Endpoint.broadcast("test_chat_channel", "new_message", data)
    render conn, "create.html"
  end
end
