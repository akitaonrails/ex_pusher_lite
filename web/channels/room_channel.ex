defmodule ExPusherLite.RoomChannel do
  use Phoenix.Channel
  use Guardian.Channel

  # no auth is needed for public topics
  def join("public:" <> _topic_id, _auth_msg, socket) do
    {:ok, socket}
  end

  def join(topic, %{ claims: claims, resource: _resource }, socket) do
    if permitted_topic?(claims[:listen], topic) do
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
    claims = Guardian.Channel.claims(socket)
    if permitted_topic?(claims[:publish], socket.topic) do
      broadcast socket, topic_event, payload
      { :noreply, socket }
    else
      { :reply, :error, socket }
    end
  end

  def permitted_topic?(nil, _), do: false
  def permitted_topic?([], _), do: false

  def permitted_topic?(permitted_topics, topic) do
    matches = fn permitted_topic ->
      pattern = String.replace(permitted_topic, ":*", ":.*")
      Regex.match?(~r/\A#{pattern}\z/, topic)
    end
    Enum.any?(permitted_topics, matches)
  end
end