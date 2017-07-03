defmodule ExPusherLite.Web.AppView do
  use ExPusherLite.Web, :view

  def render("index.json", %{apps: apps}) do
    %{data: render_many(apps, ExPusherLite.Web.AppView, "app.json")}
  end

  def render("show.json", %{app: app}) do
    %{data: render_one(app, ExPusherLite.Web.AppView, "app.json")}
  end

  def render("app.json", %{app: app}) do
    %{id: app.id,
      name: app.name,
      slug: app.slug,
      key: app.key,
      secret: app.secret,
      active: app.active}
  end
end
