defmodule Huephix.BootSeq do
    alias Huephix.Bridges
    alias Huephix.UserConfig

    defp boot_sequence do
        bridges = Bridges.try_connecting_to_bridges(UserConfig.read_user_data)

        case bridges do
            [_ | _] ->
                Bridges.add_bridges(bridges)
            [] ->
                raise "No valid bridges found" 
        end
    end

    def start_link do
        Task.start_link(&boot_sequence/0)
    end
end