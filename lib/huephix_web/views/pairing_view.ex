defmodule HuephixWeb.PairingView do
    use HuephixWeb, :view

    def render("index.json", %{
            bridges: bridges_data,
            connected_bridges: connected_bridges_data
        }) do
        bridges = Enum.map(bridges_data, &(%{
            id: &1.id,
            ip: &1.ip,
            user: &1.user
        }))

        connected_bridges = Enum.map(connected_bridges_data, &(%{
            ip: &1.host,
            user: &1.username
        }))

        %{
            status: "OK",
            bridges: bridges,
            connected_bridges: connected_bridges
        }
    end
end