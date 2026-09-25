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
  require Record

  # the main Erlang public_key header file.
  @header_file "include/public_key.hrl"

  @doc """
  Returns the list of all records defined in `public_key` module.
  """
  @spec list_records() :: [atom()]
  def list_records() do
    case :code.lib_dir(:public_key) do
      {:error, reason} -> {:error, reason}
      path ->
        target = Path.join([path, @header_file])
        {:ok, tokens} = :epp.parse_file(target, source_name: :pp)
        for {:attribute, _, :record, {record_name,_}} <- tokens, do: record_name
    end
  end

  @doc """
  A wrapper around `Record.extract/2` function to extract information
  about the Erlang record from Elixir.
  """
  def extract(record) do
    Record.extract(record, from_lib: Path.join(["public_key", @header_file]))
  end

  @doc false
  defmacro __using__(opts) do

    # the name is passed in options when importing the macro
    name = Keyword.get(opts, :name)

    # the record fields are extracted from the headers
    # defined at the beginning of the module, outside
    # of this macro
    fields = extract(name)

    # the keys are extracted from the fields, those must
    # be atoms.
    keys = for {k, _} <- fields, do: k

    # the size of the full record, including its name.
    size = length(fields)+1

    quote do
      import Expki.PublicKey

      # build the structure
      defstruct unquote(fields)

      @doc """
      Returns the name of the Erlang record as atom().
      """
      @spec name() :: atom()
      def name(), do: unquote(name)

      @doc """
      Returns the full length of the record, including its name.
      """
      @spec length() :: integer()
      def length(), do: unquote(size)

      @doc """
      Returns the record fields as defined, with its
      default values.
      """
      @spec fields() :: Keyword.t()
      def fields(), do: unquote(fields)

      @doc """
      Returns the keys of the record.
      """
      @spec keys() :: [atom()]
      def keys(), do: unquote(keys)

      @doc """
      Convert a record as a struct, or a struct as a record.
      """
      @spec convert(%__MODULE__{} | tuple()) :: {:ok, %__MODULE__{} | tuple()}
      def convert(struct = %__MODULE__{}) do
        map = Map.from_struct(struct)
        {:ok, Enum.reduce(fields(), [], fn ({k, _}, acc) -> [Map.get(map, k)|acc] end)
          |> Enum.reverse()
          |> (fn(xs) -> [name()|xs] end).()
          |> List.to_tuple()
        }
      end
      def convert(record) when is_tuple(record) do
        if is_valid?(record) do
          # convert the record as list and drop the first
          # elements (record name)
          record_list = 
            Tuple.to_list(record)
            |> Enum.drop(1)

          {:ok, keys()
            |> Enum.zip(record_list)
            |> Enum.reduce(%__MODULE__{}, fn ({k, v}, acc) -> Map.put(acc, k, v) end)
          }
        else
          {:error, :invalid_record}
        end
      end
      def convert(_), do: {:error, :invalid_input}

      @doc ""
      def convert!(input) do
        with {:ok, result} <- convert(input) do 
          result
        else
          error -> throw error
        end
      end

      @doc """
      Check if the record used is matching the record definition
      of this module.
      """
      @spec is_valid?(tuple()) :: boolean()
      def is_valid?(record) 
        when is_tuple(record) and :erlang.size(record) == unquote(size) and :erlang.element(1, record) == unquote(name), 
          do: true
      def is_valid?(_), do: false
    end
  end
end
