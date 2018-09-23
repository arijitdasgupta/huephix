defmodule HuephixWeb.SequencesController do
    use HuephixWeb, :controller
    alias Huephix.{Repo, Sequence}
    alias HuephixWeb.SharedView.CommonView

    # Reference
    # user_path  GET     /users           HelloWeb.UserController :index
    # user_path  GET     /users/:id/edit  HelloWeb.UserController :edit
    # user_path  GET     /users/new       HelloWeb.UserController :new
    # user_path  GET     /users/:id       HelloWeb.UserController :show
    # user_path  POST    /users           HelloWeb.UserController :create
    # user_path  PATCH   /users/:id       HelloWeb.UserController :update
    #         PUT     /users/:id       HelloWeb.UserController :update
    # user_path  DELETE  /users/:id       HelloWeb.UserController :delete

    def index(conn, _params) do
        render conn, "index.json", data: Repo.all(Sequence)
    end

    def show(conn, params) do
        try do
            {sequence_id, _} = Integer.parse(params["id"])
            case Repo.get(Sequence, sequence_id) do
                nil -> conn |> put_status(404) |> render(CommonView, "404.json")
                seq -> conn |> render("show.json", data: seq)
            end
        rescue
            e in MatchError -> 
                conn |> put_status(400) |> render(CommonView, "400.json")
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
            Repo.update(Sequence.changeset(existing_sequence, params))
            render conn, CommonView, "ok.json"
        rescue
            e in MatchError ->
                conn |> put_status(400) |> render(CommonView, "400.json")
            e in Ecto.NoResultsError ->
                conn |> put_status(404) |> render(CommonView, "404.json")
        end
    end

    def delete(conn, params) do
        try do
            {sequence_id, _} = Integer.parse(params["id"])
            existing_sequence = Repo.get!(Sequence, sequence_id)
            Repo.delete(existing_sequence)
            render conn, CommonView, "ok.json"
        rescue
            e in MatchError ->
                conn |> put_status(400) |> render(CommonView, "400.json")
            e in Ecto.NoResultsError ->
                conn |> put_status(404) |> render(CommonView, "404.json")
        end
    end
end