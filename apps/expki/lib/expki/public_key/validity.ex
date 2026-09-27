defmodule Expki.PublicKey.Validity do
  @moduledoc """
  - see: https://www.rfc-editor.org/info/rfc3280/#section-4.1.2.5
  - see: https://en.wikipedia.org/wiki/GeneralizedTime
  """
  use Expki.PublicKey, name: :Validity

  # TODO: add datetime check.
  def create(not_before = %DateTime{} , not_after = %DateTime{}) do
    %__MODULE__ {
      notBefore: not_before,
      notAfter: not_after
    }
  end

  # TODO: create a converter from DateTime to Generalized time
  # def to_generalized(%DateTime{}), do: ...
end
