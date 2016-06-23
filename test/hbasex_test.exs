defmodule HbasexTest do
  use ExUnit.Case
  doctest Hbasex

  test "put and get" do
    Hbasex.put("abc", "123", %{"a:c1" => "efg", "a:c2" => "hjk"})
    result = Hbasex.get("abc", "123")
    assert result == %{"a:c1" => "efg", "a:c2" => "hjk"}
   end
end
