defmodule Huephix.Sequence do
  use Ecto.Schema
  import Ecto.Changeset

  alias Huephix.Utils.Sequences

  schema "sequences" do
    field :data, :map
    field :name, :string
    field :loop, :boolean

    timestamps()
  end

  def validate_from_bridges(changeset) do
    data = fetch_field(changeset, :data)
    try do
      Sequences.validate_bridge_sequence_data!(data)
      changeset
    rescue
      _ in _ -> add_error(changeset, :bridges, "Invalid bridges data")
    end
  end

  @doc false
  def changeset(sequence, attrs) do
    sequence
    |> cast(attrs, [:name, :loop, :data])
    |> validate_required([:name, :loop, :data])
    |> validate_from_bridges()
  end
end
