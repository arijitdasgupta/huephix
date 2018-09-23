defmodule Huephix.Utils.Sequences do
    alias Huephix.Bridges

    def validate_bridge_sequence_data!(sequence_data) do
        {:changes, %{"bridges" => bridges}} = sequence_data
        bridges
            |> Enum.uniq_by(&(&1["host"]))
            |> Enum.map(&(IO.inspect(&1)))
            |> Enum.filter(&(Bridges.get_bridge_by_host(&1["host"])))
            |> Enum.filter(fn bridge -> 
                bridge["sequence"] |> Enum.each(
                    fn seq -> 
                        %{"scene" => scene, "time" => time} = seq
                        case is_integer(time) and is_bitstring(scene) do
                            false -> raise :error
                            true -> nil
                        end
                    end
                )
            end)
    end
end