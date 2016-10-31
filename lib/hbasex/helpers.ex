defmodule Hbasex.Helpers do

  @spec filter_columns_containing([String.t]) :: String.t
  def filter_columns_containing(qualifiers) do
    Enum.map(qualifiers, fn(qualifier) ->
      "QualifierFilter (=, 'substring:#{qualifier}')"
    end) |> Enum.join(" OR ")
  end
end
