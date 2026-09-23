defmodule Expki.Certificates.Key do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keys" do
    field :key, :string

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [])
    |> validate_required([])
  end
end
