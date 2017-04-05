defmodule Distrix.Supervisor do
  defmacro __using__(_) do
    quote do
      @strategy :one_for_one

      def start_link do
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
      end

      def init([]) do
        children = [
          worker(Linker.Worker.One, [], id: :one)
        ]

        supervise(@children, strategy: @strategy)
      end

      def start_a_child do
        pid = Process.whereis(__MODULE__)
        children = Supervisor.count_children(pid)
        Supervisor.start_child(pid, worker(Linker.Worker.One, [], id: count_of_children()[:workers]))
      end

      def count_of_children do
        pid = Process.whereis(__MODULE__)
        Supervisor.count_children(pid)
      end

      def enqueue_to(worker) do
        pids = Supervisor.which_children(__MODULE__)
               |> Enum.filter(fn(x) -> elem(x, 3) == [worker] end)
               |> Enum.map(fn(x) -> elem(x, 1) end)

        filt = Distrix.Queue.all
               |> Enum.filter(fn(x) -> Enum.member?(pids, elem(x, 1).pid) end)
               |> Enum.map(fn(x) -> pid = elem(x, 1).pid end)

        Enum.map(pids, fn(id) -> {id, Enum.count(filt, fn(x) -> x == id end)} end)
        |> Enum.sort_by(fn(x) -> elem(x, 1) end)
        |> Enum.at(0) |> elem(0)
      end

      def enqueue(worker, params) do
        sid = SecureRandom.uuid()
        __MODULE__.enqueue_to(worker)
        |> worker.enqueue(params, sid)
        {:ok, true}
      end
    end
  end
end
