defmodule Huephix.Repo.Migrations.CreateHueBridges do
  use Ecto.Migration

  def change do
    create table(:hue_bridges) do
      add :ip, :string
      add :user, :string

      timestamps()
    end

  end
end
