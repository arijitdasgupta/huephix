defmodule HuephixWeb.AlertController do
    use HuephixWeb, :controller
    import Huephix.Utils.Lights, only: [blink: 1]

    @number_of_alert_blinks Application.get_env(:huephix, :number_of_alert_blinks)

    def alert(conn, _params) do
        Task.start(fn -> blink(@number_of_alert_blinks) end)

        render conn, "ok.json"
    end
  end
  