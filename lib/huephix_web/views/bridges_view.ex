defmodule HuephixWeb.BridgesView do
    use HuephixWeb, :view

    def render("index.json", %{data: bridges}) do
        render_many(
            bridges,
            HuephixWeb.BridgesView,
            "bridge.json",
            as: :data
        )
    end

    def render("bridge.json", %{data: bridge}) do
        %{
            id: bridge.id,
            ip: bridge.ip,
            user: bridge.user
        }
    end

    def render("404.json", %{data: nil}) do
        %{error: "Bridge not found"}
    end

    def render("400.json", %{data: nil}) do
        %{error: "Bad parameter"}
    end
end