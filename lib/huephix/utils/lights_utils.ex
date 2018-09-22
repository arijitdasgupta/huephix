defmodule Huephix.Utils.Lights do
    alias Huephix.HueWrapper
    alias Huephix.Bridges
    
    def clamp_brightness_value(brightness) do
        brightness = cond do
            brightness > 100 -> 100
            brightness < 0 -> 0
            true -> brightness
        end

        Kernel.trunc((brightness / 100) * 255)
    end

    def act_on_all_bridges(funk) do
        bridges = Bridges.get_bridges()
        Enum.each(bridges, funk)
    end

    def blink() do
        act_on_all_bridges(fn(bridge) ->
            HueWrapper.blink(bridge)
        end)
    end

    def blink(n) do
        blink()
        cond do
            n > 1 ->
                :timer.sleep(2000)
                blink(n - 1)
            true -> nil
        end
    end
end