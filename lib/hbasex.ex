defmodule Hbasex do
  alias Hbasex.Models.TGet
  alias Hbasex.Models.TColumn
  alias Hbasex.Models.TColumnValue
  alias Hbasex.Models.TPut

  #def start(_type, _args) do
  #  import Supervisor.Spec, warn: false
  #  children = [worker(Hbasex.Client, [])]

  #  opts = [strategy: :one_for_one, name: Hbasex.Supervisor]
  #  Supervisor.start_link(children, opts)
  #end

  def start_link(host, port) do
    Hbasex.Client.start_link(host, port)
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

  def get(client_pid, table_name, row, columns \\ []) do
    tcolumns = for column <- columns, do: get_t_column(column)
    tget = TGet.new(attributes: :dict.new(), row: row, columns: tcolumns)
    result = Hbasex.Client.get(client_pid, table_name, tget)

    Enum.reduce(result.columnValues, %{}, fn(x, acc) ->
      column_name = x.family <> ":" <> x.qualifier
      Map.put(acc, column_name, x.value)
    end)
  end

  def put(client_pid, table_name, row, map) do
    Hbasex.Client.put(client_pid, table_name, get_t_put(row, map))
  end
end
