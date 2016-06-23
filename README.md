# Hbasex
[![Travis](https://img.shields.io/travis/adrienmo/hbasex.svg?branch=master&style=flat-square)](https://travis-ci.org/adrienmo/hbasex)
[![Hex.pm](https://img.shields.io/hexpm/v/hbasex.svg?style=flat-square)](https://hex.pm/packages/hbasex)

A HBase driver for Elixir using HBase Thrift Interface (v2)

## Usage

```elixir
{:ok, client_pid} = Hbasex.start_link("127.0.0.1", 9090)

Hbasex.put(client_pid, "abc", "123", %{"a:c1" => 1, "a:c2" => 2})

Hbasex.get(client_pid, "abc", "123")
```
