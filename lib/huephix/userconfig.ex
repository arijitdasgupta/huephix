defmodule Huephix.UserConfig do
    alias Huephix.{Repo, HueBridge}

    def read_user_data do
        {
            :ok,
            Repo.all(HueBridge)
        }
    end

    def update_user_data(bridges) do
        bridges
            |> Enum.map(&(HueBridge.changeset(%HueBridge{}, %{ip: &1.host, user: &1.username})))
            |> Enum.map(&(Repo.insert(&1)))
    end

    def delete_user_data do
        Repo.delete_all(HueBridge)
    end
end