defmodule Hbasex do
  use Application

  alias Hbasex.Models.{TGet, TColumn, TColumnValue, TPut, TScan}

  @default_host "localhost"
  @default_thrift_port 9090
  @default_rest_port 8080

  def start(_type, _args) do
    config = get_config()
    Hbasex.Pool.start_link(config)
  end

  defp get_config(config \\ nil) do
    config = if is_nil(config) do
      Application.get_all_env(:hbasex) |> Map.new()
    else
      config
    end
    config
    |> Map.put_new(:thrift_port, @default_thrift_port)
    |> Map.put_new(:rest_port, @default_rest_port)
  end

  def connect(config \\ %{}) do
    config
    |> get_config()
    |> Hbasex.Pool.connect()
  end

  def delete(config \\ nil, table_name) do
    config = get_config(config)
    Hbasex.RestClient.delete(config, table_name)
  end

  def create(config \\ nil, table_name, column_family) do
    config = get_config(config)
    Hbasex.RestClient.create(config, table_name, column_family)
  end

  def get(table_name, row, columns \\ []) do
    tcolumns = for column <- columns, do: get_t_column(column)
    tget = TGet.new(attributes: :dict.new(), row: row, columns: tcolumns)
    Hbasex.Pool.exec(:get, [table_name, tget])
    |> parse_row_result()
  end

  def put(table_name, row, map) do
    Hbasex.Pool.exec(:put, [table_name, get_t_put(row, map)])
  end

  def scan(table_name, nb_rows, options \\ []) do
    Hbasex.Pool.exec(:getScannerResults, [table_name, get_t_scan(options), nb_rows])
    |> Enum.map(&parse_row_result/1)
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

  defp get_t_scan(options) do
    options = expand_scan_options(options)
    options = if is_nil(options[:attributes]) do
      [{:attributes, :dict.new()}| options]
    else
      options
    end
    TScan.new(options)
  end

  defp parse_row_result(result) do
    Enum.reduce(result.columnValues, %{}, fn(x, acc) ->
      column_name = x.family <> ":" <> x.qualifier
      Map.put(acc, column_name, x.value)
    end)
  end

  defp expand_scan_options(acc), do: expand_scan_options(acc, [])
  defp expand_scan_options([], acc), do: acc
  defp expand_scan_options([{:prefix, prefix}| rest], acc) do
    preprefix_size = byte_size(prefix) - 1
    <<preprefix::binary-size(preprefix_size), last>> = prefix
    stop_row = preprefix <> <<last + 1>>
    acc = [{:startRow, prefix}, {:stopRow, stop_row} | acc]
    expand_scan_options(rest, acc)
  end
  defp expand_scan_options([kv | rest], acc) do
    expand_scan_options(rest, [kv | acc])
  end
end
