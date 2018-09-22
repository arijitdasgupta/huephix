defmodule HuephixWeb.SequencesController do
    use HuephixWeb, :controller

    def index(conn, _params) do
        render conn, "index.json"
    end
end