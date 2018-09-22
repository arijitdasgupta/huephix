defmodule Huephix.Utils.Hue do
    def map_to_ok_err(bridge) do
        case bridge.status do
            :error -> {:error, bridge}
            _ -> {:ok, bridge}
        end
    end
end