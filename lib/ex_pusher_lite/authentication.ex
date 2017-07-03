defmodule ExPusherLite.Authentication do
  import Plug.Conn

  alias ExPusherLite.Models
  alias ExPusherLite.Models.App

  def init(assigns \\ [admin: false]), do: assigns

  def call(conn, assigns) do
    token =
      if assigns[:admin] do
        ExPusherLite.Application.admin_secret
      else
        params = fetch_query_params(conn).params
        params["app_slug"] |> Models.get_app_by_slug |> App.hashed_secret
      end

    "Basic " <> auth_token = hd(get_req_header(conn, "authorization"))
    if Plug.Crypto.secure_compare(auth_token, token) do
      conn
    else
      conn |> send_resp(401, "") |> halt
    end
  end
end
