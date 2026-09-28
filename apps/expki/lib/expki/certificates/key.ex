defmodule Expki.Certificates.Key do
  use Ecto.Schema
  import Ecto.Changeset
  alias Expki.Certificates.Certificate

  schema "keys" do
    field :key, :string
    field :sha256, :string

    has_many :certificates, Certificate

    timestamps()
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:key, :sha256])
    |> validate_required([:key, :sha256])
    |> validate_private_key(:key)
    |> unique_constraint(:sha256)
  end

  def validate_private_key(changeset, field) do
    validate_change(changeset, field, fn (_,value) ->
      case Expki.Keys.verify_private_key(value) do
        {:ok, _} -> []
        {:error, error} -> [{field, error}]
      end
    end)
  end
end
