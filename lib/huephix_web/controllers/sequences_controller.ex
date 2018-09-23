defmodule HuephixWeb.SequencesController do
    use HuephixWeb, :controller
    alias Huephix.{Repo, Sequence}
    alias HuephixWeb.ErrorView

    def index(conn, _params) do
        render conn, "index.json", data: Repo.all(Sequence)
    end

    def show(conn, params) do
        try do
            {sequence_id, _} = Integer.parse(params["id"])
            seq = Repo.get!(Sequence, sequence_id)
            render(conn, "show.json", data: seq)
        rescue
            _ in MatchError -> 
                conn |> put_status(400) |> render(ErrorView, "400.json")
            _ in Ecto.NoResultsError ->
                conn |> put_status(404) |> render(ErrorView, "404.json")
        end
    end

    def create(conn, params) do        
        {:ok, new_sequence} = Repo.insert(Sequence.changeset(%Sequence{}, params))
        render conn, "show.json", data: new_sequence
    end

    def update(conn, params) do
        try do
            {sequence_id, _} = Integer.parse(params["id"])
            existing_sequence = Repo.get!(Sequence, sequence_id)
            {:ok, seq} = Repo.update(Sequence.changeset(existing_sequence, params))
            render conn, "show.json", data: seq
        rescue
            _ in MatchError ->
                conn |> put_status(400) |> render(ErrorView, "400.json")
            _ in Ecto.NoResultsError ->
                conn |> put_status(404) |> render(ErrorView, "404.json")
        end
    end

    def delete(conn, params) do
        try do
            {sequence_id, _} = Integer.parse(params["id"])
            existing_sequence = Repo.get!(Sequence, sequence_id)
            Repo.delete(existing_sequence)
            render conn, ErrorView, "ok.json"
        rescue
            _ in MatchError ->
                conn |> put_status(400) |> render(ErrorView, "400.json")
            _ in Ecto.NoResultsError ->
                conn |> put_status(404) |> render(ErrorView, "404.json")
        end
    end
end