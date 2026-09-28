defmodule Expki.Certificates.Key do
  use Ecto.Schema
  import Ecto.Changeset
  alias Expki.Certificates.Certificate

  schema "keys" do
    field :key, :string

    has_many :certificates, Certificate

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [])
    |> validate_required([:key])
  end
end
