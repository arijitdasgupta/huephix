defmodule Huephix.HueWrapper do
    require Logger

    import Huephix.Utils.Hue, only: :functions

    alias Huephix.Utils.PStore

    @application_name Application.get_env(:huephix, :hue_application_name)

    def start_link do
        Logger.info("#{__MODULE__} Agent starting")
        Agent.start_link(fn -> 
            {:ok, pid} = PStore.start_link()
            %{loop_store_pid: pid}
        end, name: __MODULE__)
    end

    defp connect(ip, username) do
        Huex.connect(ip, username)
    end

    defp connect(ip) do
        Huex.connect(ip) |> Huex.authorize(@application_name)
    end

    def find_and_connect_all do
        find_hue_bridges() |> Enum.map(&(hueconnect &1))
    end

    defp find_hue_bridges do
        Huex.Discovery.discover()
    end

    def hueconnect(ipAddr, username) do
        Logger.info "Connecting to Hue bridge (#{ipAddr}) with existing username, password"
        
        connect(ipAddr, username) |> map_to_ok_err
    end

    defp hueconnect(ipAddr) do
        Logger.info "Connecting to the Hue bridge at (#{ipAddr})"
        
        connect(ipAddr) |> map_to_ok_err
    end

    defp find_and_set_scene(bridge, scene_name) do
        sceneToSet = String.downcase(scene_name)
        allScenes = Huex.scenes(bridge)

        scenedIds = allScenes |> Enum.filter(
            fn {_, sceneObj} -> String.downcase(sceneObj["name"]) === sceneToSet end
        ) |> Enum.map(fn {sceneId, _} -> sceneId end)

        # Take the first sceneId and roll with it...
        case scenedIds do 
            [sceneId | _] -> operate_all_lights(bridge, &(Huex.set_group_state(
                &1,
                &2,
                %{"scene": sceneId}
            )))
            _ -> nil
        end
    end

    defp operate_all_lights(bridge, funk) do
        funk.(bridge, 0)
    end

    defp add_to_the_loop_store(loop_pid) do
        # Adding the new loops pid to the loop store
        Agent.get(__MODULE__, fn %{loop_store_pid: loop_store_pid} -> 
            PStore.add_pid(loop_store_pid, loop_pid)
        end)
    end

    defp kill_all_loops_in_loop_store do
       # Purging the existing loop processes
        Agent.get(__MODULE__, fn %{loop_store_pid: loop_store_pid} -> 
            loop_task_pids = PStore.get_pids(loop_store_pid)
            Enum.each(loop_task_pids, fn task_pid -> 
                Process.exit(task_pid, :kill)
            end) # Looping and killing all the process that was there for the loop
            PStore.purge_pids(loop_store_pid) # Clearning the pids
        end) 
    end

    defp operate_on_lights_with_delay(bridge, lights, funk) do
        [ light_id | lights ] = lights
        funk.(light_id)

        :timer.sleep(Kernel.trunc(:rand.uniform() * 15000))

        case lights do
            [] -> :ok
            lights -> operate_on_lights_with_delay(bridge, lights, funk)
        end
    end

    defp get_all_light_ids(bridge) do
        light_maps = Huex.lights(bridge)
        Enum.map(light_maps, fn {light_id, _} -> light_id end)
    end

    def set_scene(bridge, scene_name) do
        stop_loop(bridge)
        find_and_set_scene(bridge, scene_name)
    end

    def set_brightness(bridge, brightness) do
        operate_all_lights(bridge, &(Huex.set_group_state(&1, &2, %{
            "bri": brightness
        })))
    end

    def turn_on_lights(bridge) do
        operate_all_lights(bridge, &Huex.turn_group_on/2)
    end

    def turn_off_lights(bridge) do
        operate_all_lights(bridge, &Huex.turn_group_off/2)
    end

    def blink(bridge) do
        operate_all_lights(bridge, &(Huex.set_group_state(&1, &2, %{
            "alert": "select"
        })))
    end

    def start_loop(bridge) do
        lights = get_all_light_ids(bridge)

        {:ok, loop_pid} = Task.start(fn -> operate_on_lights_with_delay(bridge, lights,
            fn (light_id) -> 
                Huex.set_state(bridge, light_id, %{
                    "effect": "colorloop"
                })
            end)
        end)

        add_to_the_loop_store(loop_pid)
    end

    def stop_loop(bridge) do
        kill_all_loops_in_loop_store()

        # Operating on lights
        operate_all_lights(bridge, &(Huex.set_group_state(&1, &2, %{
            "effect": "none"
        })))
    end
end