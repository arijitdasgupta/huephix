defmodule HuephixWeb.SharedView.CommonView do
    use HuephixWeb, :view

    def render("404.json", _) do
        %{error: "Not found"}
    end

    def render("400.json", _) do
        %{error: "Bad request"}
    end

    def render("ok.json", _) do
        %{status: "OK"}
    end
end