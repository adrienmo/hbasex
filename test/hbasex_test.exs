defmodule HbasexTest do
  use ExUnit.Case
  doctest Hbasex

  setup_all do
    Hbasex.delete("abc")
    Hbasex.delete("scan_test")
    Hbasex.create("abc",["a"])
    Hbasex.create("scan_test",["a"])
    :ok
  end

  test "put and get" do
    Hbasex.put("abc", "123", %{"a" => %{"c1" => "efg", "c2" => "hjk"}})
    result = Hbasex.get("abc", "123")
    assert result == %{"a" => %{"c1" => "efg", "c2" => "hjk"}}

    result = Hbasex.get("abc", "123", %{"a" => ["c2"]})
    assert result == %{"a" => %{"c2" => "hjk"}}

    result = Hbasex.get("abc", "123", %{"a" => ["random_value"]})
    assert result == %{}
   end

  test "scan" do
    Hbasex.put("scan_test", "10#10000", %{"a" => %{"value" => "9"}})
    Hbasex.put("scan_test", "12#10000", %{"a" => %{"value" => "1"}})
    Hbasex.put("scan_test", "12#10001", %{"a" => %{"value" => "2"}})
    Hbasex.put("scan_test", "12#10002", %{"a" => %{"value" => "3"}})
    Hbasex.put("scan_test", "12#10003", %{"a" => %{"value" => "4"}})
    Hbasex.put("scan_test", "12#同道", %{"a" => %{"value" => "2"}})
    Hbasex.put("scan_test", "15#10003", %{"a" => %{"value" => "1"}})

    assert length(Hbasex.scan("scan_test", 10, prefix: "12#")) == 5
    assert length(Hbasex.scan("scan_test", 2, prefix: "12#")) == 2
    assert length(Hbasex.scan("scan_test", 10)) == 7
    assert Hbasex.scan("scan_test", 10, prefix: "15#") == [{"15#10003", %{"a" => %{"value" => "1"}}}]
  end
end
