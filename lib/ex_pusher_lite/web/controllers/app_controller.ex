defmodule ExPusherLite.Web.AppController do
  use ExPusherLite.Web, :controller

  alias ExPusherLite.Models
  alias ExPusherLite.Models.App
  plug ExPusherLite.Authentication, [admin: true]
  plug :scrub_params, "app" when action in [:create, :update]

  def index(conn, _params) do
    apps = Models.list_apps
    render(conn, "index.json", apps: apps)
  end

  def create(conn, %{"app" => app_params}) do
    with {:ok, %App{} = app} <- Models.create_app(app_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", app_path(conn, :show, app))
      |> render("show.json", app: app)
    end
  end

  def show(conn, %{"id" => id}) do
    app = Models.get_app!(id)
    render(conn, "show.json", app: app)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    app = Models.get_app!(id)
    with {:ok, %App{} = app} <- Audio.update_app(app, app_params) do
      render(conn, "show.json", app: app)
    end
  end

  def delete(conn, %{"id" => id}) do
    app = Models.get_app!(id)
    with {:ok, %App{}} <- Audio.delete_app(app) do
      send_resp(conn, :no_content, "")
    end
  end
end
