defmodule HuephixWeb.AlertController do
    use HuephixWeb, :controller
    import Huephix.Utils.Lights, only: [blink: 0]

    def alert(conn, _params) do
        blink()

        render conn, "index.json"
    end
  end
  