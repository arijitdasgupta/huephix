defmodule HuephixWeb.BridgesController do
    use HuephixWeb, :controller

    alias Huephix.Bridges
    alias Huephix.{Repo, HueBridge}

    defp is_in_connected_bridges(bridge) do
        case Enum.find(Bridges.get_bridges(), fn connected_bridge ->
            bridge.ip === connected_bridge.host
        end) do
            nil -> nil
            _ -> bridge
        end
    end

    def index(conn, _params) do
        bridges = Bridges.get_bridges() 
            |> Enum.map(&(&1.host))
            |> Enum.map(&(Repo.get_by(HueBridge, ip: &1)))
            |> Enum.filter(
                fn x -> case x do
                    nil -> false
                    _ -> true
                end 
            end)
        
        render conn, "index.json", data: bridges
    end

    def show(conn, params) do
        conn_404 = conn |> put_status(404)
        conn_400 = conn |> put_status(400)

        case Integer.parse(params["id"]) do
            {bridge_id, _} -> 
                case Repo.get(HueBridge, bridge_id) do
                    nil -> conn_404 |> render("404.json", data: nil)
                    bridge -> case is_in_connected_bridges(bridge) do
                        nil -> conn_404 |> render("404.json", data: nil)
                        bridge -> render conn, "bridge.json", data: bridge
                    end
                end
            :error -> conn_400 |> render("400.json", data: nil)
        end
    end
end