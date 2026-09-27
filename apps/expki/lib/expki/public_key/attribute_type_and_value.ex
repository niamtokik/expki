defmodule Expki.PublicKey.AttributeTypeAndValue do
  @moduledoc """
  AttributeTypeAndValue like defined in [RFC3280.A1](https://www.rfc-editor.org/info/rfc3280/#appendix-A.1)
  """
  use Expki.PublicKey, name: :AttributeTypeAndValue
  alias Expki.PublicKey

  @doc """
  Return the CN field.
  @TODO: improve the guards
  """
  @spec country_name(charlist()) :: %__MODULE__{}
  def country_name(cn) when is_binary(cn) do
    cn
    |> String.to_charlist()
    |> country_name()
  end
  def country_name(cn) when is_list(cn) and length(cn) <= 2 do
    %__MODULE__{
      type: PublicKey.macro(:"id-at-countryName"),
      value: cn
    }
  end

  # the common types found in the rdn sequence to create:
  # TODO: organizational_name()
  # TODO: organizational_unit()
  # TODO: state()
  # TODO: common_name()
  # TODO: serial_number()
end
