defmodule ExPusherLite.Web.RoomChannelTest do
  use ExPusherLite.Web.ChannelCase

  alias ExPusherLite.Web.RoomChannel
  alias ExPusherLite.Models.App
  alias ExPusherLite.Repo

  setup do
    secret_key = "0987654321"

    Repo.insert! %App{
      slug: "test-app",
      name: "Test App",
      key: "1234567890",
      secret: secret_key,
      active: true }

    token_code = "csrf-token-1234"

    jwt = Base.encode64(:crypto.hmac(:sha256, secret_key, token_code))

    claims = %{
      "aud" => "csrf",
      "sub" => {},
      "iss" => "pl-web-production",
      "iat" => Guardian.Utils.timestamp,
      "exp" => Guardian.Utils.timestamp + 100_00,
      "s_csrf" => jwt,
      "listen" => ["public:*", "private:test-app:*"],
      "publish" => ["public:*", "private:test-app:*"]
    }

    signed_claim = claims
                    |> Joken.token
                    |> Joken.with_signer(Joken.hs256(token_code))

    {:ok, guardian_payload: %{"guardian_token" => token_code, "guardian_csrf" => signed_claim}}
  end

  test "broadcasts to public general channel", %{guardian_payload: guardian_payload} do
    {:ok, _, socket} = socket()
      |> subscribe_and_join(RoomChannel, "public:test-app", guardian_payload)

    message = %{"name" => "Fabio", "message" => "Hello World"}
    _ = push socket, "msg", message
    assert_broadcast "msg", message
  end

  test "broadcasts to public named channel", %{guardian_payload: guardian_payload} do
    {:ok, _, socket} = socket()
      |> subscribe_and_join(RoomChannel, "public:test-app", guardian_payload)

    message = %{"name" => "Fabio", "message" => "Hello World"}
    _ = push socket, "mychannel:msg", message
    assert_broadcast "mychannel:msg", message
  end

  # test "broadcasts to private named channel", %{guardian_payload: guardian_payload} do
  #   {:ok, _, socket} = socket()
  #     |> subscribe_and_join(RoomChannel, "private:test-app:hello", guardian_payload)

  #   message = %{"name" => "Fabio", "message" => "Hello World"}
  #   ref = push socket, "msg", message
  #   assert_broadcast "msg", message
  # end
end
