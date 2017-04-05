# Distrix

Distrix is a distributed queueing system.

## Installation

(Not available yet)
If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `distrix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:distrix, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/distrix](https://hexdocs.pm/distrix).

## Usage

### Supervisors

To setup distributed workers set up a supervisor like so..
```
defmodule MyApp.Supervisor do
  use Supervisor
  @children [
    worker(MyApp.Worker, [])
    worker(MyApp.Worker, [])
  ]
  use Distrix.Supervisor
end
```
This will set up a supervisor that supervises two `MyApp.Worker` workers

### Workers

To setup workers add
```
defmodule Linker.Worker.Sender do
  def perform(params) do
    IO.inspect("My worker is running with #{params}")
    :timer.sleep(5000)
  end
  use Distrix.Worker
end
```

### Running jobs

Now all you you need to do is tell the supervisor to in call run a job is:
```
MyApp.Supervisor.enqueue(MyApp.Worker, params)
```

## Todo
* [ ] Distributed Jobs by queue count
* [ ] Retries
* [ ] Back offs
* [ ] Persisted queue before shutdown
* [ ] Tests
* [ ] Docs
