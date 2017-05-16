defmodule Hbasex.Pool do
  @moduledoc """
  Supervisor of worker pool.
  """
  use Supervisor

  @default_pool :default
  @default_pool_size 10
  @default_max_overflow 0
  @max_restarts Application.get_env(:hbasex, :max_restarts, 3)
  @max_seconds Application.get_env(:hbasex, :max_seconds, 5)

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, [name: __MODULE__])
  end

  def init(config) do
    children = if is_nil(config[:host]) and is_nil(config[:thrift_port]) do
      []
    else
      [get_child_specs(config)]
    end
    supervise(children, strategy: :one_for_one, max_restarts: @max_restarts,
                        max_seconds: @max_seconds, name: __MODULE__)
  end

  def connect(config) do
    Supervisor.start_child(__MODULE__, get_child_specs(config))
  end

  def exec(fun, args) do
    :poolboy.transaction(@default_pool, fn(worker) ->
      Hbasex.Worker.exec(worker, fun, args)
    end)
  end

  defp get_child_specs(config) do
    config = config
    |> Map.put_new(:pool_size, @default_pool_size)
    |> Map.put_new(:max_overflow, @default_max_overflow)

    pool_options = [
      name: {:local, @default_pool},
      worker_module: Hbasex.Worker,
      size: config.pool_size,
      max_overflow: config.max_overflow
    ]

    :poolboy.child_spec(@default_pool, pool_options, config)
  end
end
