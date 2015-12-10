defmodule ExPusherLite.AppTest do
  use ExPusherLite.ModelCase

  alias ExPusherLite.App

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{name: "abc"}

  test "changeset with valid attributes" do
    changeset = App.changeset(%App{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = App.changeset(%App{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "generates a proper slug" do
    changeset = App.changeset(%App{}, %{name: "123 hello $%^ world!"})
    app = Repo.insert!(changeset)
    assert app.slug == "123-hello-world"
  end

  test "generates proper key and secrets" do
    changeset = App.changeset(%App{}, @valid_attrs)
    app = Repo.insert!(changeset)
    assert is_binary(app.key)
    assert is_binary(app.secret)
    assert String.length(app.key) == 36
    assert String.length(app.secret) == 36
  end
end
