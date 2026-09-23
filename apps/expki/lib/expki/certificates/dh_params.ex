defmodule Expki.Certificates.DHParam do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dh_params" do
    field :param, :string

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [])
    |> validate_required([])
  end
end
