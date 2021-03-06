defmodule Rumbl.Multimedia.Category do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "categories" do
    field(:name, :string)

    timestamps()
  end

  def alphabetical(query) do
    from(c in query, order_by: c.name)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
