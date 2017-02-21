defmodule Hbasex do
  use Application

  alias Hbasex.Models.{TGet, TColumn, TColumnValue, TPut, TScan, TDelete}

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

  def delete_table(config \\ nil, table_name) do
    config = get_config(config)
    Hbasex.RestClient.delete(config, table_name)
  end

  def create_table(config \\ nil, table_name, column_family) do
    config = get_config(config)
    Hbasex.RestClient.create(config, table_name, column_family)
  end

  def get!(table_name, row, options \\ %{}) do
    {:ok, result} = get(table_name, row, options)
    result
  end

  def get(table_name, row, options \\ %{}) do
    try do
      tcolumns = if is_nil(options[:columns]), do: nil, else: prepare_columns(options[:columns])
      tget = TGet.new(attributes: :dict.new(), row: row, columns: tcolumns, filterString: options[:filter_string])
      {:ok, Hbasex.Pool.exec(:get, [table_name, tget])
      |> parse_row_result()
      |> elem(1)}
    catch
      :exit, log ->
        extract_errors(log)
    end
  end

  def prepare_columns(columns) do
    for {family, qualifiers} <- columns do
      for qualifier <- qualifiers do
        TColumn.new(family: family, qualifier: qualifier)
      end
    end
    |> List.flatten
  end

  def put!(table_name, row, map) do
    {:ok, result} = put(table_name, row, map)
    result
  end

  def put(table_name, row, map) do
    try do
      result = Hbasex.Pool.exec(:put, [table_name, get_t_put(row, map)])
      {:ok, result}
    catch
      :exit, log ->
        extract_errors(log)
    end
  end

  def delete!(table_name, row) do
    {:ok, result} = delete(table_name, row)
    result
  end

  def delete(table_name, row) when is_bitstring(row) do
    try do
      result = Hbasex.Pool.exec(:deleteSingle, [table_name, get_t_delete(row)])
      {:ok, result}
    catch
      :exit, log ->
        extract_errors(log)
    end
  end

  def delete(table_name, rows) when is_list(rows) do
    try do
      t_deletes = rows |> Enum.map(&get_t_delete/1)
      results = Hbasex.Pool.exec(:deleteMultiple, [table_name, t_deletes])
      {:ok, results}
    catch
      :exit, log ->
        extract_errors(log)
    end
  end

  def scan!(table_name, nb_rows, options \\ []) do
    {:ok, results} = scan(table_name, nb_rows, options)
    results
  end

  def scan(table_name, nb_rows, options \\ []) do
    try do
      results = Hbasex.Pool.exec(:getScannerResults, [table_name, get_t_scan(options), nb_rows])
      |> Enum.map(&parse_row_result/1)
      {:ok, results}
    catch
      :exit, log ->
        extract_errors(log)
    end
  end

  defp get_t_put(row, map) do
    column_values = for {family, columns} <- map do
      for {qualifier, value} <- columns do
        TColumnValue.new(family: family, qualifier: qualifier, value: value)
      end
    end
    |> List.flatten
    TPut.new(attributes: :dict.new(), row: row, columnValues: column_values)
  end

  defp get_t_delete(row, args \\ []) do
    args = [{:row, row} | args]
    args = if is_nil(args[:attributes]) do
      [{:attributes, :dict.new()}| args]
    else
      args
    end
    TDelete.new(args)
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
    {
      result.row,
      result.columnValues
      |> Enum.reduce(%{}, fn(x, acc) ->
        Map.update(acc, x.family, %{x.qualifier => x.value},
          &(Map.put(&1, x.qualifier, x.value)))
      end)
    }
  end

  defp extract_errors(log) do
    case log do
      {{_, {_,{:exception, error}}}, _}  ->
        {:error, error}
      _ ->
        {:error, nil}
    end
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
