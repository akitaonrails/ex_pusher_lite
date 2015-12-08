defmodule ExPusherLite.RoomChannel do
  use Phoenix.Channel

  def join("test_chat_channel", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_message", %{"name" => name, "message" => message}, socket) do
    broadcast! socket, "new_message", %{name: name, message: message}
    {:noreply, socket}
  end

  def handle_out("new_message", payload, socket) do
    push socket, "new_message", payload
    {:noreply, socket}
  end
end