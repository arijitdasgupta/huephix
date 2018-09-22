defmodule HuephixWeb.AlertView do
    use HuephixWeb, :view

    def render("ok.json", _) do
        %{status: "OK"}
    end
end