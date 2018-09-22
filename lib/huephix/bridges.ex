defmodule Huephix.Bridges do
    require Logger
    alias Huephix.HueWrapper

    def start_link do
        Logger.info "#{__MODULE__} Agent starting"
        Agent.start_link(fn -> %{bridges: []} end, name: __MODULE__)
    end

    def add_bridges(newBridges) do
        Logger.info "#{__MODULE__} Agent adding #{inspect(newBridges)}"
        Agent.update(__MODULE__, fn(d) -> 
            bridges = d.bridges ++ newBridges
            %{bridges: bridges}
        end)
    end

    def get_bridges() do
        Agent.get(__MODULE__, fn bridges -> 
            case bridges.bridges do
                nil -> nil
                bridges -> bridges
            end
        end)
    end

    def filter_and_map_to_valid_bridges(bridgesOkTuple) do
        bridgesOkTuple |> Enum.filter(fn(bridge) -> 
            case bridge do
                {:ok, _} -> true
                {:error, _} -> false
            end
        end) |> Enum.map(fn(bridge) -> 
            {:ok, bridge} = bridge
            bridge
        end)
    end

    def try_connecting_to_bridges(user_data) do
        bridgedOkTuple = case user_data do
            {:ok, bridges} -> Enum.map(
                bridges,
                &(HueWrapper.hueconnect(&1.ip, &1.user))
            )
            {:error, _} -> HueWrapper.find_and_connect_all()
        end

        filter_and_map_to_valid_bridges(bridgedOkTuple)
    end
end