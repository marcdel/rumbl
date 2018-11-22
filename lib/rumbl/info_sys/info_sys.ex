defmodule Rumbl.InfoSys do
  alias Rumbl.InfoSys

  @backends [InfoSys.Wolfram]
  @timeout 10_000

  defmodule Result do
    defstruct score: 0, text: nil, url: nil, backend: nil
  end

  def compute(query, opts \\ []) do
    timeout = opts[:timeout] || @timeout
    backends = opts[:backends] || @backends
    opts = Keyword.put_new(opts, :limit, 10)

    backends
    |> Enum.map(&async_query(&1, query, opts))
    |> Task.yield_many(timeout)
    |> Enum.map(fn {task, response} ->
      response || Task.shutdown(task, :brutal_kill)
    end)
    |> Enum.flat_map(fn
      {:ok, results} -> results
      {:error, _reason} -> []
    end)
    |> Enum.sort(&(&1.score >= &2.score))
    |> Enum.take(opts[:limit])
  end

  defp async_query(backend, query, opts) do
    Task.Supervisor.async_nolink(
      InfoSys.TaskSupervisor,
      backend,
      :compute,
      [query, opts],
      shutdown: :brutal_kill
    )
  end
end
