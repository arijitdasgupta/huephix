defmodule HuephixWeb.LightsController do
    use HuephixWeb, :controller

    alias Huephix.HueWrapper

    import Huephix.Utils.Lights, only: :functions

    def brightness(conn, _params) do
        {:ok, body, _} = read_body(conn)

        {brightness, _} = Integer.parse(body)
        
        brightness = clamp_brightness_value(brightness)

        act_on_all_bridges(fn(bridge) ->
            HueWrapper.set_brightness(bridge, brightness)
        end)

        render conn, "index.json"
    end

    def on(conn, _params) do
        act_on_all_bridges(fn(bridge) ->
            HueWrapper.turn_on_lights(bridge)
        end)

        render conn, "index.json"
    end

    def blink(conn, _params) do
        blink()

        render conn, "index.json"
    end

    def loop_start(conn, _params) do
        act_on_all_bridges(fn(bridge) -> 
            HueWrapper.start_loop(bridge)
        end)

        render conn, "index.json"
    end

    def loop_stop(conn, _params) do
        act_on_all_bridges(fn(bridge) -> 
            HueWrapper.stop_loop(bridge)
        end)

        render conn, "index.json"
    end

    def scene(conn, _params) do
        {:ok, body, _} = read_body(conn)

        act_on_all_bridges(fn(bridge) ->
            HueWrapper.set_scene(bridge, body)
        end)

        render conn, "index.json"
    end

    def off(conn, _params) do
        act_on_all_bridges(fn(bridge) -> 
            HueWrapper.turn_off_lights(bridge)
        end)

        render conn, "index.json"
    end
  end
  