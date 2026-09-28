defmodule Expki.Certificates do
  @moduledoc """
  The Certificates context.
  """

  import Ecto.Query, warn: false
  alias Expki.Repo

  alias Expki.Certificates.Certificate

  @doc """
  verify if a certificate is valid and supported before
  inserting it
  """
  def verify_certificate(cert) do
    case :public_key.pem_decode(cert) do
      # der entry, the certificate start with
      #   -----BEGIN CERTIFICATE-----
      [der_entry = {:Certificate, _data, :not_encrypted}] ->
        certificate_der(der_entry)

      # TODO: pem entry
      # [...]
      
      _ ->
        {:error, :not_supported}
    end
  end

  defp certificate_der({type, data, _}) do
    :public_key.der_decode(type, data)
    |> Expki.PublicKey.Certificate.convert()
  end

  @doc """
  Returns the list of certificates.

  ## Examples

      iex> list_certificates()
      [%Certificate{}, ...]

  """
  def list_certificates do
    Repo.all(Certificate)
  end

  @doc """
  Gets a single certificate.

  Raises `Ecto.NoResultsError` if the Certificate does not exist.

  ## Examples

      iex> get_certificate!(123)
      %Certificate{}

      iex> get_certificate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_certificate!(id) do
    Certificate
    |> Repo.get!(id)
    |> Repo.preload(:key)
  end

  @doc """
  Creates a certificate.

  ## Examples

      iex> create_certificate(%{field: value})
      {:ok, %Certificate{}}

      iex> create_certificate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_certificate(attrs) do
    %Certificate{}
    |> Certificate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a certificate.

  ## Examples

      iex> delete_certificate(certificate)
      {:ok, %Certificate{}}

      iex> delete_certificate(certificate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_certificate(%Certificate{} = certificate) do
    Repo.delete(certificate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking certificate changes.

  ## Examples

      iex> change_certificate(certificate)
      %Ecto.Changeset{data: %Certificate{}}

  """
  def change_certificate(%Certificate{} = certificate, attrs \\ %{}) do
    Certificate.changeset(certificate, attrs)
  end
end
