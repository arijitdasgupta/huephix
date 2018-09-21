defmodule Huephix.BootSeq do
    alias Huephix.Bridges
    alias Huephix.UserConfigFile

    defp boot_sequence do
        validBridges = Bridges.try_connecting_to_bridges |> Bridges.get_valid_bridges
        :ok = UserConfigFile.write_bridges(validBridges)

        Bridges.set_bridges(validBridges)
    end

    def start_link do
        Task.start(&boot_sequence/0)
    end
end