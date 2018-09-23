defmodule Huephix.Repo.Migrations.Sequences do
  use Ecto.Migration

  def change do
    alter table("sequences") do
      add :loop, :boolean
    end
  end
end
