defmodule Huephix.BootupSequence do
    alias Huephix.Bridges
    alias Huephix.UserConfigFile

    def start do
        validBridges = Bridges.try_connecting_to_bridges |> Bridges.get_valid_bridges

        :ok = UserConfigFile.write_bridges(validBridges)

        Bridges.set_bridges(validBridges)
    end
end