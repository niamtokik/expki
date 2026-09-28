defmodule Expki.Certificates.Certificate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Expki.Certificates.Key

  schema "certificates" do
    field :name, :string
    field :is_request, :boolean
    field :is_ca, :boolean
    field :is_signed, :boolean

    field :certificate, :string
    belongs_to :key, Key

    field :serial, :string
    field :not_before, :utc_datetime
    field :not_after, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [:name, :is_request, :is_ca, :is_signed, :certificate, :not_before, :not_after, :serial, :key_id])
    |> cast_assoc(:key)
    |> validate_required([:name, :is_request, :is_ca, :is_signed, :certificate, :not_before, :not_after, :serial])
    |> unique_constraint([:name])
    |> unique_constraint([:certificate])
    |> validate_certificate(:certificate)
  end

  def validate_certificate(changeset, field) do
    validate_change(changeset, field, fn (_, value) ->
      case Expki.Certificates.verify_certificate(value) do
        {:ok, _} -> []
        {:error, error} -> [{field, error}]
      end
    end)
  end
end
