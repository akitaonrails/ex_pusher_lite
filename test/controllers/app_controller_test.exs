defmodule ExPusherLite.Web.AppControllerTest do
  use ExPusherLite.Web.ConnCase

  alias ExPusherLite.Models
  alias ExPusherLite.Models.App
  @valid_attrs %{ name: "some content" }
  @invalid_attrs %{ name: "abc" }

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Basic #{ExPusherLite.Application.admin_secret}")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, app_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    app = create_app()
    conn = get conn, app_path(conn, :show, app.slug)
    assert json_response(conn, 200)["data"] == %{"id" => app.id,
      "name" => app.name,
      "slug" => app.slug,
      "key" => app.key,
      "secret" => app.secret,
      "active" => app.active}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, app_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, app_path(conn, :create), app: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(App, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, app_path(conn, :create), app: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    app = create_app()
    conn = put conn, app_path(conn, :update, app.slug), app: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(App, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    app = create_app()
    conn = put conn, app_path(conn, :update, app.slug), app: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    changeset = App.changeset(%App{}, @valid_attrs)
    app = Repo.insert!(changeset)
    conn = delete conn, app_path(conn, :delete, app.slug)
    assert response(conn, 204)
    refute Repo.get(App, app.id)
  end

  defp create_app do
    {:ok, %App{} = app} = Models.create_app(@valid_attrs)
    app
  end
end
