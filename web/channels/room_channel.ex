defmodule ExPusherLite.RoomChannel do
  use Phoenix.Channel
  import Guardian.Phoenix.Socket

  # no auth is needed for public topics
  def join("public:" <> _topic_id, _auth_msg, socket) do
    {:ok, socket}
  end

  def join(topic, _resource, socket) do
    if permitted_topic?(socket, :listen, topic) do
      { :ok, %{ message: "Joined" }, socket }
    else
      { :error, :authentication_required }
    end
  end

  def join(_room, _payload, _socket) do
    { :error, :authentication_required }
  end

  def handle_in(topic_event, payload, socket = %{ topic: "public:" <> _ }) do
    broadcast socket, topic_event, payload
    { :noreply, socket }
  end

  def handle_in(topic_event, payload, socket) do
    if permitted_topic?(socket, :publish, socket.topic) do
      broadcast socket, topic_event, payload
      { :noreply, socket }
    else
      { :reply, :error, socket }
    end
  end

  def permitted_topic?(socket, claim_key, topic) do
    claims           = Guardian.Phoenix.Socket.current_claims(socket)
    permitted_topics = claims[claim_key] || []
    Enum.any?(permitted_topics, fn permitted_topic ->
      pattern = String.replace(permitted_topic, ":*", ":.*")
      Regex.match?(~r/\A#{pattern}\z/, topic)
    end)
  end
end
