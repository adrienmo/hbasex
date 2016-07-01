# Hbasex
[![Travis](https://img.shields.io/travis/adrienmo/hbasex.svg?branch=master&style=flat-square)](https://travis-ci.org/adrienmo/hbasex)
[![Hex.pm](https://img.shields.io/hexpm/v/hbasex.svg?style=flat-square)](https://hex.pm/packages/hbasex)

A HBase driver for Elixir using HBase Rest and Thrift Interface (v2)

This library leverage both REST and Thrift interface of HBase. The REST
interface is used to perform administration task on the database (table
creation and deletion). The Thrift interface is used to perform the read and
write operation. The Thrift interface use a connection pool to increase the
performance. At the moment creation and deletion of table is not supported by
the HBase Thrift Interface (v2).

## Installation

  1. Add hbasex to your list of dependencies in `mix.exs`:

        def deps do
          [{:hbasex, github: "adrienmo/hbasex", tag: "0.1.4"}]
        end

  2. Ensure hbasex is started before your application:

        def application do
          [applications: [:hbasex]]
        end

## Configuration

If you want the library to connect automatically to your HBase server at startup
add the following in your config/config.exs file

```elixir
config :hbasex,
  host: "localhost",
  thrift_port: 9090,
  rest_port: 8080,
  pool_size: 10,
  max_overflow: 0
```

## Usage

```elixir
# Using REST interface
Hbasex.create_table("abc", ["a"])

Hbasex.delete_table("abc")

# Using thrift interface
Hbasex.put("abc", "123", %{"a" => %{"c1" => 1, "c2" => 2}})

Hbasex.get("abc", "123")
Hbasex.get("abc", "123", %{"a" => ["c1"]})

Hbasex.scan("abc", 100)
Hbasex.scan("abc", 100, prefix: "user123#")

Hbasex.delete("abc", "123")
Hbasex.delete("abc", ["123", "456"])
```
