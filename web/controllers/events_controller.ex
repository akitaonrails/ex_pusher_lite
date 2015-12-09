defmodule ExPusherLite.EventsController do
  use ExPusherLite.Web, :controller

  plug :authenticate

  def create(conn, params) do
    topic = params["topic"]
    event = params["event"]
    message = (params["payload"] || "{}") |> Poison.decode!
    ExPusherLite.Endpoint.broadcast! topic, event, message
    json conn, %{}
  end

  defp authenticate(conn, _) do
    secret = Application.get_env(:ex_pusher_lite, :authentication)[:secret]
    "Basic " <> auth_token = hd(get_req_header(conn, "authorization"))
    if Plug.Crypto.secure_compare(auth_token, Base.encode64(secret)) do
      conn
    else
      conn |> send_resp(401, "") |> halt
    end
  end

end
