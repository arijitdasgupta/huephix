defmodule HuephixWeb.ScenesView do
    use HuephixWeb, :view

    def render("index.json", %{data: scenes_data}) do
        scenes_data
    end
end