defmodule Huephix.Repo.Migrations.RemoveSequencesTable do
  use Ecto.Migration

  def change do
    drop table("sequences")
  end
end
