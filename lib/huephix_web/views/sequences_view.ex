defmodule HuephixWeb.SequencesView do
    use HuephixWeb, :view

    def render("index.json", _) do
        %{sequences: []}
    end
end