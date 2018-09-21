defmodule Huephix.BootSeq do
    alias Huephix.Bridges
    alias Huephix.UserConfigFile

    defp boot_sequence do
        validBridges = Bridges.try_connecting_to_bridges |> Bridges.get_valid_bridges

        case validBridges do
            [_ | _] -> 
                :ok = UserConfigFile.write_bridges(validBridges)
                Bridges.set_bridges(validBridges)   
            [] ->
                raise "No valid bridges found" 
        end
    end

    def start_link do
        Task.start_link(&boot_sequence/0)
    end
end