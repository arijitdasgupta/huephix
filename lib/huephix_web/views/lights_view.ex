defmodule HuephixWeb.LightsView do
    use HuephixWeb, :view

    def render("ok.json", _) do
        %{status: "OK"}
    end
end