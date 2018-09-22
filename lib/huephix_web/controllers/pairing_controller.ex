defmodule HuephixWeb.PairingController do
    use HuephixWeb, :controller

    alias Huephix.HueWrapper
    alias Huephix.UserConfig
    alias Huephix.Bridges

    def pair(conn, _params) do
        bridges = HueWrapper.find_and_connect_all
            |> Bridges.filter_and_map_to_bridges

        case bridges do
            [_ | _] -> 
                UserConfig.update_user_data(bridges)                
                Bridges.add_bridges(bridges)
            _ -> nil
        end

        render conn, "index.json"
    end
end