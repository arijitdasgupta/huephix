defmodule HuephixWeb.PairingController do
    use HuephixWeb, :controller

    def pair(conn, _params) do
        render conn, "index.json"
    end
end