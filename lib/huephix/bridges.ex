defmodule Huephix.Bridges do
    require Logger
    alias Huephix.HueWrapper
    alias Huephix.UserConfig

    def start_link do
        Logger.info "#{__MODULE__} Agent starting"
        Agent.start_link(fn -> %{bridges: nil} end, name: __MODULE__)
    end

    def set_bridges(newBridges) do
        Logger.info "#{__MODULE__} Agent set to #{inspect(newBridges)}"
        Agent.update(__MODULE__, fn(_) -> 
            %{bridges: newBridges}
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

    def try_connecting_to_bridges() do
        bridgedOkTuple = case UserConfig.read_user_data do
            {:ok, bridges} -> Enum.map(
                bridges,
                &(HueWrapper.hueconnect(&1.ip, &1.user))
            )
            {:error, _} -> HueWrapper.find_and_connect_all()
        end

        bridgedOkTuple |> Enum.filter(fn(bridge) -> 
            case bridge do
                {:ok, _} -> true
                {:error, _} -> false
            end
        end) |> Enum.map(fn(bridge) -> 
            {:ok, bridge} = bridge
            bridge
        end)
    end
end