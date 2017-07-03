defmodule ExPusherLite.Models.App do
  use ExPusherLite.Web, :model
  alias ExPusherLite.Repo

  schema "apps" do
    field :name, :string
    field :slug, :string
    field :key, :string
    field :secret, :string
    field :active, :boolean, default: true

    timestamps()
  end

  @required_fields [:name]
  @optional_fields [:slug, :key, :secret, :active]

  def hashed_secret(model) do
    Base.encode64("#{model.key}:#{model.secret}")
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 5, max: 255)
    |> unique_constraint(:name)
    |> generate_key
    |> generate_secret
    |> slugify
    |> unique_constraint(:slug)
  end

  defp generate_key(model) do
    if get_field(model, :key) do
      model
    else
      model
      |> put_change(:key, SecureRandom.uuid)
    end
  end

  defp generate_secret(model) do
    if get_field(model, :secret) do
      model
    else
      model
      |> put_change(:secret, SecureRandom.uuid)
    end
  end

  defp slugify(model) do
    if name = get_change(model, :name) do
      model
      |> put_change(:slug, Slugger.slugify_downcase(name))
    else
      model
    end
  end
end
