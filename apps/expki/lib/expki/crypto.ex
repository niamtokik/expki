defmodule Expki.Crypto do
  def sha256(data) do
    :crypto.hash(:sha256, data)
      |> Base.encode64()
  end
end
