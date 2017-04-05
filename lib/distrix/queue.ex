defmodule Distrix.Queue do
  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def add(pid, params, uuid, worker) do
    GenServer.cast(@name, {:add, pid, params, uuid, worker})
  end

  def pop(pid) do
    GenServer.cast(@name, {:remove, pid})
  end

  def all do
    GenServer.call(@name, :list)
  end

  def size do
    Enum.count(all.keys)
  end

  def init(_) do
    {:ok, %{} }
  end

  def handle_cast({:add, pid, params, uuid, worker}, state) do
    {:noreply, Map.merge(state, %{ uuid =>
      %{ params: params, pid: pid, retry_count: 0, worker: worker }
    })}
  end

  def handle_cast({:remove, pid}, state) do
    {:noreply, Map.pop(state, pid) |> elem(1)}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
end
