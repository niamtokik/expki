defmodule Expki.PublicKey do
  @moduledoc """
  This module is an interface to the `public_key` Erlang module, containing a
  lot of records and other definitions. Dealing with those information on
  Elixir can be challenging, then, this module can help to convert the records
  into a struct.

  At this time, this is a minimal implementation, doing only the converstion
  between Records and Structs.

  - see: https://www.erlang.org/doc/system/ref_man_records.html
  - see: https://elixir.hexdocs.pm/Record.html

  ## Example
  
  A module for each record is required, the problem is mostly due to the name
  of the Erlang record, they are all starting with an uppercase character, and
  then, the `Record` module from Elixir can't be used.

  ```elixir
  defmodule Expli.PublicKey.RSAPrivateKey do
    use Expki.PublicKey, name: :RSAPrivateKey
  end
  ```

  The module can now be used to validate the records, convert them or create
  them from different sources.

  ```console
  iex> alias Expki.PublicKey.RSAPrivateKey

  iex> t = RSAPrivateKey.convert!(%RSAPrivateKey{})
  {:RSAPrivateKey, :undefined, :undefined, :undefined, :undefined, :undefined,
   :undefined, :undefined, :undefined, :undefined, :asn1_NOVALUE}

  iex> s = RSAPrivateKey.convert!(t)
  %Expki.PublicKey.RSAPrivateKey{
      version: :undefined,
      modulus: :undefined,
      publicExponent: :undefined,
      privateExponent: :undefined,
      prime1: :undefined,
      prime2: :undefined,
      exponent1: :undefined,
      exponent2: :undefined,
      coefficient: :undefined,
      otherPrimeInfos: :asn1_NOVALUE
    }
  ```

  iex> RSAPrivateKey.is_valid?(t)
  true

  iex> RSAPrivateKey.is_valid?({:test, :data})
  false

  """
  use Preprocessing.Macros,
    module: :public_key,
    filepath: "include/public_key.hrl"

  # This is a macro template wrapper around Preprocessing.Record, indeed,
  # all the data structure below PublicKey should be records from the
  # public_key Erlang module, then, the same definition should be applied
  # on all of them to avoid mistakes and code deduplication.
  @doc false
  defmacro __using__(opts) do
    record_id = Keyword.get(opts, :record_id)
    pem_entry_serializer = Keyword.get(opts, :pem_entry_serializer, true)

    quote do
      use Preprocessing.Record,
        record_id: unquote(record_id),
        module: :public_key,
        filepath: "include/public_key.hrl"
      import Expki.PublicKey
      alias Expki.PublicKey

      # pem_entry_serializer feature.
      unquote do
        if (pem_entry_serializer) do
          quote do
            def pem_entry_encode!(struct = %__MODULE__{}) do
              r = convert!(struct)
              :public_key.pem_entry_encode(unquote(record_id), r)
              end

            def pem_entry_decode!(string) when is_binary(string) do
              string
              |> :public_key.pem_entry_decode()
              |> convert!()
            end
          end
        end
      end

    end
  end
end
