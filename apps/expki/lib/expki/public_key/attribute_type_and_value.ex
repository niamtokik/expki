defmodule Expki.PublicKey.AttributeTypeAndValue do
  @moduledoc """
  AttributeTypeAndValue like defined in [RFC3280.A1](https://www.rfc-editor.org/info/rfc3280/#appendix-A.1)
  """
  use Expki.PublicKey, name: :AttributeTypeAndValue
  alias Expki.PublicKey

  @identifiers [
    :"id-at",
    :"id-at-commonName",
    :"id-at-countryName",
    :"id-at-dnQualifier",
    :"id-at-generationQualifier",
    :"id-at-givenName",
    :"id-at-initials",
    :"id-at-localityName",
    :"id-at-name",
    :"id-at-organizationName",
    :"id-at-organizationalUnitName",
    :"id-at-pseudonym",
    :"id-at-serialNumber",
    :"id-at-stateOrProvinceName",
    :"id-at-surname",
    :"id-at-title",
  ]

  # this part is used to genreate automatically all available
  # identifiers from public_key macros.
  for identifier <- @identifiers do
    fun_name = identifier
      |> Atom.to_string()
      |> String.replace("-", "_") 
      |> String.to_atom()

    @doc """
    Function helper to create unquote(identifier) type.
    """
    @spec unquote(fun_name)(String.t() | list()) :: %__MODULE__{}
    def unquote(fun_name)(value) when is_binary(value) do
      value
      |> String.to_charlist()
      |> unquote(fun_name)()
    end
    def unquote(fun_name)(value) when is_list(value) do
      %__MODULE__{
        type: PublicKey.macro(unquote(identifier)),
        value: value
      }
    end
  end
end
