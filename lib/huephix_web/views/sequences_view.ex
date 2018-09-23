defmodule HuephixWeb.SequencesView do
    use HuephixWeb, :view

    def render("index.json", %{data: sequences}) do
        render_many(sequences, HuephixWeb.SequencesView, "show.json", as: :data)
    end

    def render("show.json", %{data: sequence}) do
        %{
            id: sequence.id,
            name: sequence.name,
            data: sequence.data
        }
    end
end