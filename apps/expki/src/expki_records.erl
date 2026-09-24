%%%===================================================================
%%% @doc This module has been created to easily convert Erlang records
%%%      datastructure to Elixir-like data-structure, including maps
%%%      and Struct.
%%%
%%%      Indeed, lot of records (for example from public_key module)
%%%      are kinda hard to create in Elixir.
%%%
%%% @TODO create types for Elixir struct
%%%
%%% @end
%%%===================================================================
-module(expki_records).
-export([
  record_to_map/1,
  record_to_struct/1,
  struct_to_record/1
]).
-include_lib("public_key/include/public_key.hrl").

%%--------------------------------------------------------------------
%% @doc Converts an Elixir Struct to an Erlang record (tuple).
%% @end
%%--------------------------------------------------------------------
-spec struct_to_record(Struct) -> Return when
  Struct :: map(),
  Return :: tuple().

struct_to_record(Struct)
  when is_map(Struct) ->
    {}.

%%--------------------------------------------------------------------
%% @doc Converts an Erlang record to a map.
%% @end
%%--------------------------------------------------------------------
-spec record_to_map(Record) -> Return when
  Record :: tuple(),
  Return :: map().

record_to_map(Record)
  when is_tuple(Record), is_atom(element(1, Record)) ->
    ok.

%%--------------------------------------------------------------------
%% @doc Converts an Erlang record into an Elixir Struct.
%%
%% see: https://elixir.hexdocs.pm/main/structs.html
%% @end
%%--------------------------------------------------------------------
-spec record_to_struct(Record) -> Return when
  Record :: tuple(),
  Return :: map().

record_to_struct(Record)
  when is_tuple(Record), is_atom(element(1, Record)) ->
    Name = element(1, Record),
    maps:from_list([
      {'__struct__', Name}
    ]).
