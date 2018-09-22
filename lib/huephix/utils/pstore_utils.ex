defmodule Huephix.Utils.PStore do
    require Logger

    def start do
        Logger.info "PStore Agent starting"
        Agent.start(fn -> %{pids: []} end)
    end

    def add_pid(agent_pid, pid_to_add) do
        Logger.info "#{inspect(agent_pid)} Store adding #{inspect(pid_to_add)}"
        Agent.update(agent_pid, fn(d) -> 
            %{pids: d.pids ++ [pid_to_add]}
        end)
    end

    def get_pids(agent_pid) do
        Agent.get(agent_pid, fn d -> d.pids end)
    end

    def purge_pids(agent_pid) do
        Logger.info "#{inspect(agent_pid)} Store purging"
        Agent.update(agent_pid, fn(_) -> %{pids: []} end)
    end
end