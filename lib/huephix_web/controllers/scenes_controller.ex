defmodule HuephixWeb.ScenesController do
    use HuephixWeb, :controller

    alias Huephix.Bridges

    def index(conn, _param) do
        scenes = Bridges.get_bridges()
            |> Enum.reduce([], fn bridge, acc ->
                acc ++ Huex.scenes(bridge)
            end)
        IO.inspect(scenes)
        render conn, "index.json", data: scenes
    end
end