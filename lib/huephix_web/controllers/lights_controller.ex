defmodule HuephixWeb.LightsController do
    use HuephixWeb, :controller
    alias Huephix.HueWrapper
    alias Huephix.Bridges

    # user_path  GET     /users           HelloWeb.UserController :index
    # user_path  GET     /users/:id/edit  HelloWeb.UserController :edit
    # user_path  GET     /users/new       HelloWeb.UserController :new
    # user_path  GET     /users/:id       HelloWeb.UserController :show
    # user_path  POST    /users           HelloWeb.UserController :create
    # user_path  PATCH   /users/:id       HelloWeb.UserController :update
#                PUT     /users/:id       HelloWeb.UserController :update
    # user_path  DELETE  /users/:id       HelloWeb.UserController :delete

    defp clamp_brightness_value(brightness) do
        brightness = cond do
            brightness > 100 -> 100
            brightness < 0 -> 0
            true -> brightness
        end

        Kernel.trunc((brightness / 100) * 255)
    end

    defp act_on_all_bridges(funk) do
        bridges = Bridges.get_bridges()
        Enum.each(bridges, funk)
    end

    def blink do
        act_on_all_bridges(fn(bridge) ->
            HueWrapper.blink(bridge)
        end)
    end

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
  