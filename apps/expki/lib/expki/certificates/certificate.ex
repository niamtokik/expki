defmodule Expki.Certificates.Certificate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "certificates" do
    field :name, :string
    field :description, :string
    field :certificate, :string
    field :serial, :string
    field :status, :string
    field :expire_at, :utc_datetime_usec
    field :revoked_at, :utc_datetime_usec
    field :filename, :string
    field :subject, :string

    # belongs_to :certificate_authorities, CertificateAuthorities
    # belongs_to :certificate_requests, CertificateRequests

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [])
    |> validate_required([])
  end
end
