%%%===================================================================
%%% @doc DRAFT
%%%
%%%      This module has been created to easily convert Erlang records
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
  struct_to_record/1,
  list_records/2
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
%% see: https://github.com/erlang/otp/blob/237030f6583ced4bb9aa4de54912e56e0fbfde51/lib/ssl/test/cryptcookie.erl#L725
%% see: https://github.com/erlang/otp/blob/237030f6583ced4bb9aa4de54912e56e0fbfde51/lib/stdlib/src/erl_expand_records.erl#L559
%% see: https://github.com/erlang/otp/blob/237030f6583ced4bb9aa4de54912e56e0fbfde51/lib/stdlib/src/erl_expand_records.erl#L1037
%% @end
%%--------------------------------------------------------------------
-spec record_to_struct(Record) -> Return when
  Record :: tuple(),
  Return :: map().

record_to_struct(Record)
  when is_tuple(Record), is_atom(element(1, Record)) ->
    Name = element(1, Record),
    % [_|Values] = tuple_to_list(Record),
    % TODO: this can't work because record_info is not really a function,
    % it is added directly on the ast and compiled on demand. I was thinking
    % to use merl, but it seems it is not available when used with Elixir.
    % 
    % returns the raw tokens from the file:
    %
    %   epp:scan_file(".../include/public_key.hrl", []).
    %
    % return the parsed file (ast). a custom source name is required to
    % be able to compile only the header.
    %
    %   epp:parse_file(".../include/public_key.hrl", [{source_name, pp}]).
    %
    % luckily, epp module is available with elixir. So, it could be possible
    % to craft an erlang module (or an elixir module) using the AST from
    % public_key.hrl.
    % Fields = [record_info(fields, Record)],

    maps:from_list([
      {'__struct__', Name}
    ]).

list_records(Module, HeaderFile)
  when is_atom(Module) ->
  case code:lib_dir(Module) of
    {error, Reason} -> {error, Reason};
    Path when is_list(Path) ->
      Target = filename:join([Path, HeaderFile]),
      {ok, Tokens} = epp:parse_file(Target, [{source_name, pp}]),
      [ N || {attribute, _, record, {N, _}} <- Tokens ]
  end.
