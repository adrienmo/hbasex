defmodule FailureTest do
  use ExUnit.Case
  doctest Hbasex

  setup_all do
    Hbasex.delete_table("abc")
    Hbasex.create_table("abc", [])
    :ok
  end

   test "scan fails with wrong table" do
     {:error, {:TIOError, _}} = Hbasex.scan("i_do_not_exists", 10, prefix: "12#")
     {:error, {:TIOError, _}} = Hbasex.put("i_do_not_exists", "1", %{"a" => %{"a" => "1"}})
     {:error, {:TIOError, _}} = Hbasex.delete("i_do_not_exists", "1")
     {:error, {:TIOError, _}} = Hbasex.get("i_do_not_exists", "1")
   end

   test "delete empty table" do
     {:error, {:TIOError, "abc"}} = Hbasex.delete("abc", "1")
   end
end
