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
            |> Enum.map(&(%HueBridge{ip: &1.host, user: &1.username}))
            |> Enum.each(&(Repo.insert(&1))) # Update existing stuff TODO
    end
end