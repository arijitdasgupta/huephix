defmodule HuephixWeb.SequencesController do
    use HuephixWeb, :controller
    alias Huephix.{Repo, Sequence}
    alias HuephixWeb.SharedView.CommonView
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
        case Repo.insert(Sequence.changeset(%Sequence{}, params)) do
            {:ok, new_sequence} -> render conn, "show.json", data: new_sequence
            {:error, changeset} -> render conn, ErrorView, "409.validation.json", changeset: changeset
        end
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
            render conn, CommonView, "ok.json"
        rescue
            _ in MatchError ->
                conn |> put_status(400) |> render(ErrorView, "400.json")
            _ in Ecto.NoResultsError ->
                conn |> put_status(404) |> render(ErrorView, "404.json")
        end
    end

    def activate(conn, _params) do
        render conn, CommonView, "ok.json"
    end
end