defmodule Expki.Certificates.CertificateAuthority do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dh_params" do
    field :name, :string
    field :description, :string
    field :certificate, :string

    # belongs_to :key, Key

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [])
    |> validate_required([])
  end
end
