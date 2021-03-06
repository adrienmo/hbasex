defmodule Hbasex.RestClient do
  @moduledoc """
    Hbase rest API interface.
  """

  defp get_base_url(%{host: host, rest_port: rest_port}) do
    "http://" <> host <> ":" <> to_string(rest_port) <> "/"
  end

  defp get_schema_url(config, table_name) do
    base_url = get_base_url(config)
    base_url <> table_name <> "/schema"
  end

  def create(config, table_name, column_family) do
    url = get_schema_url(config, table_name)
    cf_str = column_family
    |> Enum.map(&("{\"name\":\"#{&1}\"}"))
    |> Enum.join(",")
    body = "{\"@name\":\"#{table_name}\",\"ColumnSchema\":[#{cf_str}]}"
    json_request(:post, url, body)
  end

  def delete(config, table_name) do
    url = get_schema_url(config, table_name)
    json_request(:delete, url, "")
  end

  defp json_request(verb, url, body) do
    {verb, url, body}
    body = to_charlist(body)
    url = to_charlist(url)
    request = {url, [{'Accept', 'application/json'}], 'application/json', body}
    :httpc.request(verb, request, [], [])
  end
end
