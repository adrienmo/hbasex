# Hbasex

A HBase driver for Elixir using Thrift

## Usage

```elixir
{:ok, client_pid} = Hbasex.start_link("127.0.0.1", 9090)

Hbasex.put(client_pid, "abc", "123", %{"a:c1" => 1, "a:c2" => 2})

Hbasex.get(client_pid, "abc", "123")
```
