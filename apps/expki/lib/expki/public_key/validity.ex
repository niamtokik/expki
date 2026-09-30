defmodule Expki.PublicKey.Validity do
  @moduledoc """
  - see: https://www.rfc-editor.org/info/rfc3280/#section-4.1.2.5
  - see: https://en.wikipedia.org/wiki/GeneralizedTime
  """
  use Expki.PublicKey, record_id: :Validity

  # TODO: add datetime check: 
  #   * not_before must not be greater than not_after;
  #   * not_before must not be equal to not_after;
  #   * please check those rules to be sure its correct.
  def create(not_before = %DateTime{} , not_after = %DateTime{}) do
    %__MODULE__ {
      notBefore: to_generalized_time(not_before),
      notAfter: to_generalized_time(not_after)
    }
  end

  @doc """
  Returns a generalized time format, compatible with the
  Validity attribute.
  """
  @spec to_generalized_time(%DateTime{}) :: {:utcTime, charlist()}
  def to_generalized_time(dt = %DateTime{zone_abbr: "UTC", utc_offset: 0, std_offset: 0}) do
    generalized_time = Calendar.strftime(dt, "%y%m%d%H%M%SZ", [])
                       |> String.to_charlist()
    {:utcTime, generalized_time}
  end
end
