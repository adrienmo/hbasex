defmodule HbasexTest do
  use ExUnit.Case
  doctest Hbasex

  setup_all do
    host = Application.get_env(:hbasex, :host, "localhost")
    port = Application.get_env(:hbasex, :port, 9090)
    {:ok, client_pid} = Hbasex.start_link(host, port)
    {:ok, client_pid: client_pid}
  end

  test "put and get", context do
    Hbasex.put(context.client_pid, "abc", "123", %{"a:c1" => "efg", "a:c2" => "hjk"})
    result = Hbasex.get(context.client_pid, "abc", "123")
    assert result == %{"a:c1" => "efg", "a:c2" => "hjk"}
   end
end
