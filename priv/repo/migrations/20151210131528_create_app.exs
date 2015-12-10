defmodule ExPusherLite.Repo.Migrations.CreateApp do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :name, :string
      add :slug, :string
      add :key, :string
      add :secret, :string
      add :active, :boolean, default: false

      timestamps
    end
    create index(:apps, [:name], unique: true)
    create index(:apps, [:slug], unique: true)
  end
end
