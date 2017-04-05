defmodule Distrix.Worker do
  defmacro __using__(_) do
    quote do
      use GenServer

      def start_link do
        GenServer.start_link(__MODULE__, [])
      end

      def perform_async(pid, args) do
        GenServer.cast(pid, {:perform, args})
      end

      def handle_cast({:perform, args}, state) do
        IO.puts "Started #{__MODULE__}"
        perform(args)
        IO.puts "Completed #{__MODULE__}"
        {:noreply, "done"}
      end

      def enqueue(pid, params, uuid) do
        Distrix.Queue.add(pid, params, uuid, __MODULE__)
        GenServer.cast(pid, {:perform, params, uuid})
      end

      def handle_cast({:perform, params, uuid}, state) do
        # try do
          perform(params)
          Distrix.Queue.pop(uuid)
        # rescue
        #   # Queue.pop()
        # end
        {:noreply, state}
      end
    end
  end
end
