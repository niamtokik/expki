defmodule Expki.PublicKey.Validity do
  @moduledoc """
  - see: https://www.rfc-editor.org/info/rfc3280/#section-4.1.2.5
  - see: https://en.wikipedia.org/wiki/GeneralizedTime
  """
  use Expki.PublicKey, record_id: :Validity
  alias Expki.Checker

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

  # TODO: documentation + test
  def converter(struct) do
    with {:ok,
            %__MODULE__{
            notBefore: not_before,
            notAfter: not_after
          }} <- checker(struct) do

      convert(%__MODULE__{
        notBefore: to_generalized_time(not_before),
        notAfter: to_generalized_time(not_after),
      })
    end
  end

  # TODO: documentation + test
  def checker(data) do
    Expki.Checker.check(data, [
      &check_struct/2,
      &check_not_before/2,
      &check_not_after/2,
      &check_date_range/2,
    ])
  end

  # TODO: documentation
  @spec check_struct(%__MODULE__{}, Checker.check_state()) :: Checker.check_result()
  def check_struct(%__MODULE__{}, _), do: :ok
  def check_struct(_, _), do: {:error, :invalid_struct}

  # TODO: documentation
  @spec check_not_before(%__MODULE__{}, Checker.check_state()) :: Checker.check_result()
  def check_not_before(%__MODULE__{notBefore: not_before = %DateTime{}}, _) do
    check_utc(not_before)
  end
  def check_not_before(_, _), do: {:error, {:invalid, :notBefore}}

  # TODO: documentation
  @spec check_not_after(%__MODULE__{}, Checker.check_state()) :: Checker.check_result()
  def check_not_after(%__MODULE__{notAfter: not_after = %DateTime{}}, _) do
    check_utc(not_after)
  end
  def check_not_after(_, _), do: {:error, {:invalid, :notAfter}}

  # TODO: documentation
  @spec check_date_range(%__MODULE__{}, Checker.check_state()) :: Checker.check_result()
  def check_date_range(%__MODULE__{notBefore: not_before, notAfter: not_after}, _) do
    cond do
      not_before == not_after -> {:error, :invalid}
      DateTime.before?(not_before, not_after) != true -> {:error, :invalid}
      true -> :ok
    end
  end

  # TODO: documentation
  @spec check_utc(DateTime.t()) :: :ok | {:error, term()}
  def check_utc(datetime) do
    time_zone = Map.get(datetime, :time_zone)
    zone_abbr = Map.get(datetime, :zone_abbr)
    std_offset = Map.get(datetime, :std_offset)
    utc_offset = Map.get(datetime, :utc_offset)
    cond do
      time_zone != "Etc/UTC" -> {:error, {:invalid, :time_zone}}
      zone_abbr != "UTC" -> {:error, {:invalid, :zone_abbr}}
      std_offset != 0 -> {:error, {:invalid, :std_offset}}
      utc_offset != 0 -> {:error, {:invalid, :utc_offset}}
      true -> :ok
    end
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
