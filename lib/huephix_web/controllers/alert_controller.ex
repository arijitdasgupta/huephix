defmodule HuephixWeb.AlertController do
    use HuephixWeb, :controller

    alias Huephix.Notifier
    
    import Huephix.Utils.Notifier, only: [notify_by_post: 3]
    import Huephix.Utils.Lights, only: [blink: 0]

    def create(conn, _params) do
        {:ok, body, _} = read_body(conn)
        Task.async(fn -> 
            blink()
            notify_by_post(body, 'localhost', '2300')
        end)

        render conn, "index.json"
    end
  end
  