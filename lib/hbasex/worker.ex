defmodule Hbasex.Worker do
  use GenServer

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, [])
  end

  def init(config) do
    case Hbasex.Client.start_link(config.host, config.thrift_port) do
      {:ok, pid} -> {:ok, pid}
      _ ->
        Process.send_after(self, {:connect, config}, 5_000)
        {:ok, nil}
    end
  end

  def handle_info({:connect, config}, _) do
    case Hbasex.Client.start_link(config.host, config.thrift_port) do
      {:ok, pid} -> {:noreply, pid}
      _ ->
        Process.send_after(self, {:connect, config}, 5_000)
    end
  end

  def handle_call({:exec, fun, args}, _from, pid) do
    {:reply, Kernel.apply(Hbasex.Client, fun, [pid | args]), pid}
  end

  def exec(worker, fun, args) do
    :gen_server.call(worker, {:exec, fun, args})
  end
end
