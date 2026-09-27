defmodule Expki.PublicKeyMacros do
  @moduledoc """
  This module is doing the hard job to read/parse/convert the macros
  from the public_key headers and convert hem into something usable
  in Elixir. When used inside another module, a `macro/1` function
  is created to extract easily the macros
  """

  @doc """
  Returns the list of defined macros in public_key header file as
  Keyword.t().
  """
  @spec definitions() :: {:ok, Keyword.t()}
  def definitions() do
    case :code.lib_dir(:public_key) do
      {:error, reason} -> {:error, reason}
      path ->
        with {:ok, pid} <- open_file(path),
          :ok <- definitions_loop(pid),
          {:ok, macros} <- definitions_macros(pid)
        do
          convert_macros(macros, [])
        end
    end
  end

  @spec open_file(list()) :: {:ok, pid()}
  defp open_file(path) do
    Path.join([path, "include/public_key.hrl"])
      |> String.to_charlist()
      |> :epp.open([], [])
  end

  # loop over the whole opened erlang file
  @spec definitions_loop(pid()) :: :ok
  defp definitions_loop(pid) do
    msg = :epp.parse_erl_form(pid)
    case msg do
      {:eof, _} ->
        :ok
      _ ->
        definitions_loop(pid)
    end
  end

  # retrieve the macros from epp server. The returned value
  # must be checked though.
  @spec definitions_macros(pid()) :: {:ok, list()}
  defp definitions_macros(pid) do
    send(pid, {:epp_request, self(), :macro_defs})
    receive do
      {:epp_reply, pid, macros} ->
        :epp.close(pid)
        {:ok, macros}
      msg ->
        :epp.close(pid)
        {:error, msg}
      after
        10000 ->
          :epp.close(pid)
          {:error, :timeout}
      end
  end

  # convert the list of macros returned by the epp server
  # into something we can use in Elixir (terms). The name
  # of the macros is the key
  # TODO: the keys containing :ignored are discarted from
  # the final result
  @spec convert_macros(list(), list()) :: {:ok, Keyword.t()}
  defp convert_macros([], buffer) do 
    {:ok, 
      buffer
        |> Enum.filter(fn({_, v}) -> if v==:ignored do false else true end end)
    }
  end
  defp convert_macros([macro={{:atom, name}, value}|rest], buffer) do
    with {:ok, term} <- convert_macro_value(value) do
      convert_macros(rest, [{name, term}|buffer])
    else
      error -> {:error, error, macro}
    end
  end

  # convert a macro with 0 arity (:none), it should be
  # enough for the moment
  # TODO: add support for macros arity (convert them into 
  # lambda functions.
  defp convert_macro_value([none: {:none, value}]) do
    # TODO: a check is required here, most of the time, the code from the
    # macros don't contain any dot (.) char at the end, and then, it
    # must be added to let parse_term correctly convert the tokens
    # into valid erlang terms.
    with {:ok, term} <- :erl_parse.parse_term(value ++ [{:dot, 1131}]) do
      {:ok, term}
    end
  end
  defp convert_macro_value(_), do: {:ok, :ignored}

  # concat key and values and escape them
  defp escape() do
    with {:ok, defs} <- definitions() do
      key_value = defs
      value_key = defs
        |> Enum.map(fn({k,v}) -> {v,k} end)

      as_map = Enum.concat(key_value, value_key)
        |> :maps.from_list()
      Macro.escape(as_map)
    end
  end

  # returns only the macro keys
  defp macro_keys() do
    with {:ok, defs} <- definitions() do
      defs
      |> Enum.map(fn({k,_}) -> k end)
      |> Macro.escape()
    end
  end

  # returns only the macro values
  defp macro_values() do 
    with {:ok, defs} <- definitions() do
      defs
      |> Enum.map(fn({_,v}) -> v end)
      |> Macro.escape()
    end
  end

  @doc false
  defmacro __using__(_opts) do
    defs = escape()

    quote do
      import Expki.PublicKeyMacros

      def macros(), do: unquote(defs)

      def macro(index) do
        Map.get(unquote(defs), index)
      end

      def macro_keys(), do: unquote(macro_keys())

      def macro_values(), do: unquote(macro_values())
    end
  end
end
