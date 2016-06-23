-ifndef(_hbase_types_included).
-define(_hbase_types_included, yeah).

-define(HBASE_TDELETETYPE_DELETE_COLUMN, 0).
-define(HBASE_TDELETETYPE_DELETE_COLUMNS, 1).

-define(HBASE_TDURABILITY_SKIP_WAL, 1).
-define(HBASE_TDURABILITY_ASYNC_WAL, 2).
-define(HBASE_TDURABILITY_SYNC_WAL, 3).
-define(HBASE_TDURABILITY_FSYNC_WAL, 4).

-define(HBASE_TCOMPAREOP_LESS, 0).
-define(HBASE_TCOMPAREOP_LESS_OR_EQUAL, 1).
-define(HBASE_TCOMPAREOP_EQUAL, 2).
-define(HBASE_TCOMPAREOP_NOT_EQUAL, 3).
-define(HBASE_TCOMPAREOP_GREATER_OR_EQUAL, 4).
-define(HBASE_TCOMPAREOP_GREATER, 5).
-define(HBASE_TCOMPAREOP_NO_OP, 6).

%% struct 'TTimeRange'

-record('TTimeRange', {'minStamp' :: integer(),
                       'maxStamp' :: integer()}).
-type 'TTimeRange'() :: #'TTimeRange'{}.

%% struct 'TColumn'

-record('TColumn', {'family' :: string() | binary(),
                    'qualifier' :: string() | binary(),
                    'timestamp' :: integer()}).
-type 'TColumn'() :: #'TColumn'{}.

%% struct 'TColumnValue'

-record('TColumnValue', {'family' :: string() | binary(),
                         'qualifier' :: string() | binary(),
                         'value' :: string() | binary(),
                         'timestamp' :: integer(),
                         'tags' :: string() | binary()}).
-type 'TColumnValue'() :: #'TColumnValue'{}.

%% struct 'TColumnIncrement'

-record('TColumnIncrement', {'family' :: string() | binary(),
                             'qualifier' :: string() | binary(),
                             'amount' = 1 :: integer()}).
-type 'TColumnIncrement'() :: #'TColumnIncrement'{}.

%% struct 'TResult'

-record('TResult', {'row' :: string() | binary(),
                    'columnValues' = [] :: list()}).
-type 'TResult'() :: #'TResult'{}.

%% struct 'TAuthorization'

-record('TAuthorization', {'labels' :: list()}).
-type 'TAuthorization'() :: #'TAuthorization'{}.

%% struct 'TCellVisibility'

-record('TCellVisibility', {'expression' :: string() | binary()}).
-type 'TCellVisibility'() :: #'TCellVisibility'{}.

%% struct 'TGet'

-record('TGet', {'row' :: string() | binary(),
                 'columns' :: list(),
                 'timestamp' :: integer(),
                 'timeRange' :: 'TTimeRange'(),
                 'maxVersions' :: integer(),
                 'filterString' :: string() | binary(),
                 'attributes' :: dict:dict(),
                 'authorizations' :: 'TAuthorization'()}).
-type 'TGet'() :: #'TGet'{}.

%% struct 'TPut'

-record('TPut', {'row' :: string() | binary(),
                 'columnValues' = [] :: list(),
                 'timestamp' :: integer(),
                 'attributes' :: dict:dict(),
                 'durability' :: integer(),
                 'cellVisibility' :: 'TCellVisibility'()}).
-type 'TPut'() :: #'TPut'{}.

%% struct 'TDelete'

-record('TDelete', {'row' :: string() | binary(),
                    'columns' :: list(),
                    'timestamp' :: integer(),
                    'deleteType' = 1 :: integer(),
                    'attributes' :: dict:dict(),
                    'durability' :: integer()}).
-type 'TDelete'() :: #'TDelete'{}.

%% struct 'TIncrement'

-record('TIncrement', {'row' :: string() | binary(),
                       'columns' = [] :: list(),
                       'attributes' :: dict:dict(),
                       'durability' :: integer(),
                       'cellVisibility' :: 'TCellVisibility'()}).
-type 'TIncrement'() :: #'TIncrement'{}.

%% struct 'TAppend'

-record('TAppend', {'row' :: string() | binary(),
                    'columns' = [] :: list(),
                    'attributes' :: dict:dict(),
                    'durability' :: integer(),
                    'cellVisibility' :: 'TCellVisibility'()}).
-type 'TAppend'() :: #'TAppend'{}.

%% struct 'TScan'

-record('TScan', {'startRow' :: string() | binary(),
                  'stopRow' :: string() | binary(),
                  'columns' :: list(),
                  'caching' :: integer(),
                  'maxVersions' = 1 :: integer(),
                  'timeRange' :: 'TTimeRange'(),
                  'filterString' :: string() | binary(),
                  'batchSize' :: integer(),
                  'attributes' :: dict:dict(),
                  'authorizations' :: 'TAuthorization'(),
                  'reversed' :: boolean()}).
-type 'TScan'() :: #'TScan'{}.

%% struct 'TMutation'

-record('TMutation', {'put' :: 'TPut'(),
                      'deleteSingle' :: 'TDelete'()}).
-type 'TMutation'() :: #'TMutation'{}.

%% struct 'TRowMutations'

-record('TRowMutations', {'row' :: string() | binary(),
                          'mutations' = [] :: list()}).
-type 'TRowMutations'() :: #'TRowMutations'{}.

%% struct 'THRegionInfo'

-record('THRegionInfo', {'regionId' :: integer(),
                         'tableName' :: string() | binary(),
                         'startKey' :: string() | binary(),
                         'endKey' :: string() | binary(),
                         'offline' :: boolean(),
                         'split' :: boolean(),
                         'replicaId' :: integer()}).
-type 'THRegionInfo'() :: #'THRegionInfo'{}.

%% struct 'TServerName'

-record('TServerName', {'hostName' :: string() | binary(),
                        'port' :: integer(),
                        'startCode' :: integer()}).
-type 'TServerName'() :: #'TServerName'{}.

%% struct 'THRegionLocation'

-record('THRegionLocation', {'serverName' = #'TServerName'{} :: 'TServerName'(),
                             'regionInfo' = #'THRegionInfo'{} :: 'THRegionInfo'()}).
-type 'THRegionLocation'() :: #'THRegionLocation'{}.

%% struct 'TIOError'

-record('TIOError', {'message' :: string() | binary()}).
-type 'TIOError'() :: #'TIOError'{}.

%% struct 'TIllegalArgument'

-record('TIllegalArgument', {'message' :: string() | binary()}).
-type 'TIllegalArgument'() :: #'TIllegalArgument'{}.

-endif.
