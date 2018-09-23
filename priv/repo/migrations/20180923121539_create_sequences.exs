defmodule Huephix.Repo.Migrations.CreateSequences do
  use Ecto.Migration

  def change do
    create table(:sequences) do
      add :name, :string
      add :data, :map

      timestamps()
    end

  end
end
