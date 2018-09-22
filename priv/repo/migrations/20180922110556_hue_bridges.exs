defmodule Huephix.Repo.Migrations.HueBridges do
  use Ecto.Migration

  def change do
    create unique_index(:hue_bridges, [:ip])
  end
end
