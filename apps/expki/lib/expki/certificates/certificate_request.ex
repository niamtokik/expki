defmodule Expki.Certificates.CertificateRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "certificates" do
    field :name, :string
    field :description, :string
    field :certificate, :string

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [])
    |> validate_required([])
  end
end
