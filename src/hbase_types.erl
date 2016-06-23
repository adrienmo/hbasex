%%
%% Autogenerated by Thrift Compiler (0.9.3)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(hbase_types).

-include("hbase_types.hrl").

-export([struct_info/1, struct_info_ext/1]).

struct_info('TTimeRange') ->
  {struct, [{1, i64},
          {2, i64}]}
;

struct_info('TColumn') ->
  {struct, [{1, string},
          {2, string},
          {3, i64}]}
;

struct_info('TColumnValue') ->
  {struct, [{1, string},
          {2, string},
          {3, string},
          {4, i64},
          {5, string}]}
;

struct_info('TColumnIncrement') ->
  {struct, [{1, string},
          {2, string},
          {3, i64}]}
;

struct_info('TResult') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TColumnValue'}}}}]}
;

struct_info('TAuthorization') ->
  {struct, [{1, {list, string}}]}
;

struct_info('TCellVisibility') ->
  {struct, [{1, string}]}
;

struct_info('TGet') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TColumn'}}}},
          {3, i64},
          {4, {struct, {'hbase_types', 'TTimeRange'}}},
          {5, i32},
          {6, string},
          {7, {map, string, string}},
          {8, {struct, {'hbase_types', 'TAuthorization'}}}]}
;

struct_info('TPut') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TColumnValue'}}}},
          {3, i64},
          {5, {map, string, string}},
          {6, i32},
          {7, {struct, {'hbase_types', 'TCellVisibility'}}}]}
;

struct_info('TDelete') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TColumn'}}}},
          {3, i64},
          {4, i32},
          {6, {map, string, string}},
          {7, i32}]}
;

struct_info('TIncrement') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TColumnIncrement'}}}},
          {4, {map, string, string}},
          {5, i32},
          {6, {struct, {'hbase_types', 'TCellVisibility'}}}]}
;

struct_info('TAppend') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TColumnValue'}}}},
          {3, {map, string, string}},
          {4, i32},
          {5, {struct, {'hbase_types', 'TCellVisibility'}}}]}
;

struct_info('TScan') ->
  {struct, [{1, string},
          {2, string},
          {3, {list, {struct, {'hbase_types', 'TColumn'}}}},
          {4, i32},
          {5, i32},
          {6, {struct, {'hbase_types', 'TTimeRange'}}},
          {7, string},
          {8, i32},
          {9, {map, string, string}},
          {10, {struct, {'hbase_types', 'TAuthorization'}}},
          {11, bool}]}
;

struct_info('TMutation') ->
  {struct, [{1, {struct, {'hbase_types', 'TPut'}}},
          {2, {struct, {'hbase_types', 'TDelete'}}}]}
;

struct_info('TRowMutations') ->
  {struct, [{1, string},
          {2, {list, {struct, {'hbase_types', 'TMutation'}}}}]}
;

struct_info('THRegionInfo') ->
  {struct, [{1, i64},
          {2, string},
          {3, string},
          {4, string},
          {5, bool},
          {6, bool},
          {7, i32}]}
;

struct_info('TServerName') ->
  {struct, [{1, string},
          {2, i32},
          {3, i64}]}
;

struct_info('THRegionLocation') ->
  {struct, [{1, {struct, {'hbase_types', 'TServerName'}}},
          {2, {struct, {'hbase_types', 'THRegionInfo'}}}]}
;

struct_info('TIOError') ->
  {struct, [{1, string}]}
;

struct_info('TIllegalArgument') ->
  {struct, [{1, string}]}
;

struct_info(_) -> erlang:error(function_clause).

struct_info_ext('TTimeRange') ->
  {struct, [{1, required, i64, 'minStamp', undefined},
          {2, required, i64, 'maxStamp', undefined}]}
;

struct_info_ext('TColumn') ->
  {struct, [{1, required, string, 'family', undefined},
          {2, optional, string, 'qualifier', undefined},
          {3, optional, i64, 'timestamp', undefined}]}
;

struct_info_ext('TColumnValue') ->
  {struct, [{1, required, string, 'family', undefined},
          {2, required, string, 'qualifier', undefined},
          {3, required, string, 'value', undefined},
          {4, optional, i64, 'timestamp', undefined},
          {5, optional, string, 'tags', undefined}]}
;

struct_info_ext('TColumnIncrement') ->
  {struct, [{1, required, string, 'family', undefined},
          {2, required, string, 'qualifier', undefined},
          {3, optional, i64, 'amount', 1}]}
;

struct_info_ext('TResult') ->
  {struct, [{1, optional, string, 'row', undefined},
          {2, required, {list, {struct, {'hbase_types', 'TColumnValue'}}}, 'columnValues', []}]}
;

struct_info_ext('TAuthorization') ->
  {struct, [{1, optional, {list, string}, 'labels', []}]}
;

struct_info_ext('TCellVisibility') ->
  {struct, [{1, optional, string, 'expression', undefined}]}
;

struct_info_ext('TGet') ->
  {struct, [{1, required, string, 'row', undefined},
          {2, optional, {list, {struct, {'hbase_types', 'TColumn'}}}, 'columns', []},
          {3, optional, i64, 'timestamp', undefined},
          {4, optional, {struct, {'hbase_types', 'TTimeRange'}}, 'timeRange', #'TTimeRange'{}},
          {5, optional, i32, 'maxVersions', undefined},
          {6, optional, string, 'filterString', undefined},
          {7, optional, {map, string, string}, 'attributes', dict:new()},
          {8, optional, {struct, {'hbase_types', 'TAuthorization'}}, 'authorizations', #'TAuthorization'{}}]}
;

struct_info_ext('TPut') ->
  {struct, [{1, required, string, 'row', undefined},
          {2, required, {list, {struct, {'hbase_types', 'TColumnValue'}}}, 'columnValues', []},
          {3, optional, i64, 'timestamp', undefined},
          {5, optional, {map, string, string}, 'attributes', dict:new()},
          {6, optional, i32, 'durability', undefined},
          {7, optional, {struct, {'hbase_types', 'TCellVisibility'}}, 'cellVisibility', #'TCellVisibility'{}}]}
;

struct_info_ext('TDelete') ->
  {struct, [{1, required, string, 'row', undefined},
          {2, optional, {list, {struct, {'hbase_types', 'TColumn'}}}, 'columns', []},
          {3, optional, i64, 'timestamp', undefined},
          {4, optional, i32, 'deleteType',   1},
          {6, optional, {map, string, string}, 'attributes', dict:new()},
          {7, optional, i32, 'durability', undefined}]}
;

struct_info_ext('TIncrement') ->
  {struct, [{1, required, string, 'row', undefined},
          {2, required, {list, {struct, {'hbase_types', 'TColumnIncrement'}}}, 'columns', []},
          {4, optional, {map, string, string}, 'attributes', dict:new()},
          {5, optional, i32, 'durability', undefined},
          {6, optional, {struct, {'hbase_types', 'TCellVisibility'}}, 'cellVisibility', #'TCellVisibility'{}}]}
;

struct_info_ext('TAppend') ->
  {struct, [{1, required, string, 'row', undefined},
          {2, required, {list, {struct, {'hbase_types', 'TColumnValue'}}}, 'columns', []},
          {3, optional, {map, string, string}, 'attributes', dict:new()},
          {4, optional, i32, 'durability', undefined},
          {5, optional, {struct, {'hbase_types', 'TCellVisibility'}}, 'cellVisibility', #'TCellVisibility'{}}]}
;

struct_info_ext('TScan') ->
  {struct, [{1, optional, string, 'startRow', undefined},
          {2, optional, string, 'stopRow', undefined},
          {3, optional, {list, {struct, {'hbase_types', 'TColumn'}}}, 'columns', []},
          {4, optional, i32, 'caching', undefined},
          {5, optional, i32, 'maxVersions', 1},
          {6, optional, {struct, {'hbase_types', 'TTimeRange'}}, 'timeRange', #'TTimeRange'{}},
          {7, optional, string, 'filterString', undefined},
          {8, optional, i32, 'batchSize', undefined},
          {9, optional, {map, string, string}, 'attributes', dict:new()},
          {10, optional, {struct, {'hbase_types', 'TAuthorization'}}, 'authorizations', #'TAuthorization'{}},
          {11, optional, bool, 'reversed', undefined}]}
;

struct_info_ext('TMutation') ->
  {struct, [{1, undefined, {struct, {'hbase_types', 'TPut'}}, 'put', #'TPut'{}},
          {2, undefined, {struct, {'hbase_types', 'TDelete'}}, 'deleteSingle', #'TDelete'{}}]}
;

struct_info_ext('TRowMutations') ->
  {struct, [{1, required, string, 'row', undefined},
          {2, required, {list, {struct, {'hbase_types', 'TMutation'}}}, 'mutations', []}]}
;

struct_info_ext('THRegionInfo') ->
  {struct, [{1, required, i64, 'regionId', undefined},
          {2, required, string, 'tableName', undefined},
          {3, optional, string, 'startKey', undefined},
          {4, optional, string, 'endKey', undefined},
          {5, optional, bool, 'offline', undefined},
          {6, optional, bool, 'split', undefined},
          {7, optional, i32, 'replicaId', undefined}]}
;

struct_info_ext('TServerName') ->
  {struct, [{1, required, string, 'hostName', undefined},
          {2, optional, i32, 'port', undefined},
          {3, optional, i64, 'startCode', undefined}]}
;

struct_info_ext('THRegionLocation') ->
  {struct, [{1, required, {struct, {'hbase_types', 'TServerName'}}, 'serverName', #'TServerName'{}},
          {2, required, {struct, {'hbase_types', 'THRegionInfo'}}, 'regionInfo', #'THRegionInfo'{}}]}
;

struct_info_ext('TIOError') ->
  {struct, [{1, optional, string, 'message', undefined}]}
;

struct_info_ext('TIllegalArgument') ->
  {struct, [{1, optional, string, 'message', undefined}]}
;

struct_info_ext(_) -> erlang:error(function_clause).

