# Hbasex
[![Travis](https://img.shields.io/travis/adrienmo/hbasex.svg?branch=master&style=flat-square)](https://travis-ci.org/adrienmo/hbasex)
[![Hex.pm](https://img.shields.io/hexpm/v/hbasex.svg?style=flat-square)](https://hex.pm/packages/hbasex)

A HBase driver for Elixir using HBase Thrift Interface (v2)

## Installation

  1. Add aeroex to your list of dependencies in `mix.exs`:

        def deps do
          [{:hbasex, "~> 0.1.1"}]
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
  port: 9090,
  pool_size: 10,
  max_overflow: 0
```

## Usage

```elixir
Hbasex.put("abc", "123", %{"a:c1" => 1, "a:c2" => 2})
Hbasex.get("abc", "123")
```
