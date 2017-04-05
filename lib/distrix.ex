defmodule Distrix do
  @moduledoc """
  Documentation for Distrix.
  """
  use Supervisor

  def start(_type, _args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    children = [
      worker(Distrix.Queue, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
