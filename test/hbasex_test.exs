defmodule HbasexTest do
  use ExUnit.Case
  doctest Hbasex

  setup_all do
    Hbasex.delete_table("abc")
    Hbasex.delete_table("scan_test")
    Hbasex.delete_table("delete_test")
    Hbasex.create_table("abc",["a"])
    Hbasex.create_table("scan_test",["a"])
    Hbasex.create_table("delete_test",["a"])
    :ok
  end

  test "put and get" do
    Hbasex.put!("abc", "123", %{"a" => %{"c1" => "efg", "c2" => "hjk"}})
    result = Hbasex.get!("abc", "123")
    assert result == %{"a" => %{"c1" => "efg", "c2" => "hjk"}}

    result = Hbasex.get!("abc", "123", %{"a" => ["c2"]})
    assert result == %{"a" => %{"c2" => "hjk"}}

    result = Hbasex.get!("abc", "123", %{"a" => ["random_value"]})
    assert result == %{}
   end

  test "scan" do
    Hbasex.put!("scan_test", "10#10000", %{"a" => %{"value" => "9"}})
    Hbasex.put!("scan_test", "12#10000", %{"a" => %{"value" => "1"}})
    Hbasex.put!("scan_test", "12#10001", %{"a" => %{"value" => "2"}})
    Hbasex.put!("scan_test", "12#10002", %{"a" => %{"value" => "3"}})
    Hbasex.put!("scan_test", "12#10003", %{"a" => %{"value" => "4"}})
    Hbasex.put!("scan_test", "12#同道", %{"a" => %{"value" => "2"}})
    Hbasex.put!("scan_test", "15#10003", %{"a" => %{"value" => "1"}})

    assert length(Hbasex.scan!("scan_test", 10, prefix: "12#")) == 5
    assert length(Hbasex.scan!("scan_test", 2, prefix: "12#")) == 2
    assert length(Hbasex.scan!("scan_test", 10)) == 7
    assert Hbasex.scan!("scan_test", 10, prefix: "15#") == [{"15#10003", %{"a" => %{"value" => "1"}}}]
  end

  test "put and delete" do
    for i <- 1..10 do
      Hbasex.put!("delete_test", to_string(i), %{"a" => %{"a" => "1"}})
    end
    assert length(Hbasex.scan!("delete_test", 10)) == 10

    Hbasex.delete!("delete_test", "1")
    assert Hbasex.get!("delete_test", "1") == %{}
    assert Hbasex.get!("delete_test", "2") != %{}

    Hbasex.delete!("delete_test", ["2", "3", "4"])
    assert length(Hbasex.scan!("delete_test", 10)) == 6
  end
end
