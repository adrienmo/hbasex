defmodule Hbasex.Worker do
  use GenServer

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, [])
  end

  def init(config) do
    {:ok, pid} = Hbasex.Client.start_link(config.host, config.thrift_port)
    {:ok, pid}
  end

  def handle_call({:exec, fun, args}, _from, pid) do
    {:reply, Kernel.apply(Hbasex.Client, fun, [pid | args]), pid}
  end

  def exec(worker, fun, args) do
    :gen_server.call(worker, {:exec, fun, args})
  end
end
