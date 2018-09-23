defmodule Huephix.Utils.Sequences do
    alias Huephix.Bridges

    def validate_bridge_sequence_data!(sequence_data) do
        %{"bridges" => bridges} = sequence_data
        bridges
            |> Enum.filter(&(Bridges.get_bridge_by_host(&1["host"])))
            |> Enum.filter(fn bridge -> 
                bridge["sequence"] |> Enum.each(
                    fn seq -> 
                        case seq do
                            # Validate {scene, time} structure
                            %{"scene" => scene, "time" => time} ->  
                                case is_integer(time) and is_bitstring(scene) do
                                    false -> raise :error
                                    true -> nil
                                end
                            # Vaidate {stop, time} structure
                            %{"stop" => true, "time" => time} -> 
                                case is_integer(time) do
                                    false -> raise :error
                                    true -> nil
                                end
                        end
                    end
                )
            end)
    end

    def get_uniq_bridges_from_sequence_data(sequence_data) do
        %{"bridges" => bridges} = sequence_data
        %{"bridges" => Enum.uniq_by(bridges, &(&1["host"]))}
    end
end