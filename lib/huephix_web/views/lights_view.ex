defmodule HuephixWeb.LightsView do
    use HuephixWeb, :view

    def render("index.json", _) do
        %{status: "OK"}
    end
end