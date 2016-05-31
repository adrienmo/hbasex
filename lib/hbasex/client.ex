defmodule Hbasex.Client do
  use Riffed.Client,
  structs: Hbasex.Models,
  client_opts: [retries: 3],
  service: :t_h_base_service_thrift,
  import: [
    :exists,
    :get,
    :getMultiple,
    :put,
    :checkAndPut,
    :putMultiple,
    :deleteSingle,
    :deleteMultiple,
    :checkAndDelete,
    :increment,
    :append,
    :openScanner,
    :getScannerRows,
    :closeScanner,
    :mutateRow,
    :getScannerResults,
    :getRegionLocation,
    :getAllRegionLocations,
    :checkAndMutate
  ]

  defenum TCompareOp do
    :less -> 0
    :less_or_equal -> 1
    :equal -> 2
    :not_equal -> 3
    :greater_or_equal -> 4
    :greater -> 5
    :no_op -> 6
  end

  defenum TDeleteType do
    :delete_column -> 0
    :delete_columns -> 1
  end

  defenum TDurability do
    :skip_wal -> 1
    :async_wal -> 2
    :sync_wal -> 3
    :fsync_wal -> 4
  end

  enumerize_struct TDelete, deleteType: TDeleteType
  enumerize_struct TDelete, durability: TDurability
  enumerize_struct TPut, durability: TDurability
  enumerize_struct TIncrement, durability: TDurability
  enumerize_struct TAppend, durability: TDurability
  enumerize_function checkAndMutate(_, _, _, _, TCompareOp, _, _)
end
