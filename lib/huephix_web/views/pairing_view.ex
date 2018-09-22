defmodule HuephixWeb.PairingView do
    use HuephixWeb, :view

    def render("index.json", %{bridges: bridges_data}) do
        bridges = Enum.map(bridges_data, &(%{
            ip: &1.ip,
            user: &1.user
        }))

        %{status: "OK", bridges: bridges}
    end

    def render("ok.json", _) do
        %{status: "OK"}
    end
end