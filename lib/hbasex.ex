defmodule Hbasex do
  use Application

  alias Hbasex.Models.{TGet, TColumn, TColumnValue, TPut, TScan}

  @default_host "localhost"
  @default_port 9090

  def start(_type, _args) do
    config = Application.get_all_env(:hbasex) |> Map.new()
    Hbasex.Pool.start_link(config)
  end

  def connect(config \\ %{}) do
    config
    |> Map.put_new(:host, @default_host)
    |> Map.put_new(:port, @default_port)
    |> Hbasex.Pool.connect()
  end

  def get(table_name, row, columns \\ []) do
    tcolumns = for column <- columns, do: get_t_column(column)
    tget = TGet.new(attributes: :dict.new(), row: row, columns: tcolumns)
    result = Hbasex.Pool.exec(:get, [table_name, tget])

    Enum.reduce(result.columnValues, %{}, fn(x, acc) ->
      column_name = x.family <> ":" <> x.qualifier
      Map.put(acc, column_name, x.value)
    end)
  end

  def put(table_name, row, map) do
    Hbasex.Pool.exec(:put, [table_name, get_t_put(row, map)])
  end

  def scan(table_name, nb_rows) do
    Hbasex.Pool.exec(:getScannerResults, [table_name, get_t_scan(), nb_rows])
  end

  defp get_t_column(column) do
    [family, qualifier] = String.split(column, ":")
    TColumn.new(family: family, qualifier: qualifier)
  end

  defp get_t_column_value(column, value) do
    [family, qualifier] = String.split(column, ":")
    TColumnValue.new(family: family, qualifier: qualifier, value: value)
  end

  defp get_t_put(row, map) do
    column_values = for {column, value} <- map do
      get_t_column_value(column, value)
    end
    TPut.new(attributes: :dict.new(), row: row, columnValues: column_values)
  end

  defp get_t_scan() do
    TScan.new(attributes: :dict.new())
  end
end
