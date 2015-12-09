defmodule ExPusherLite.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(data), do: { :ok, data }
  def from_token(data), do: { :ok, data }
end