defmodule Huephix.HueBridge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hue_bridges" do
    field :ip, :string
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(hue_bridge, attrs) do
    hue_bridge
    |> cast(attrs, [:ip, :user])
    |> validate_required([:ip, :user])
  end
end
