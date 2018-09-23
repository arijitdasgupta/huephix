defmodule Huephix.Sequence do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sequences" do
    field :data, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(sequence, attrs) do
    sequence
    |> cast(attrs, [:name, :data])
    |> validate_required([:name, :data])
  end
end
