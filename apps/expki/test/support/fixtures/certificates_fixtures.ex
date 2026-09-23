defmodule Expki.CertificatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Expki.Certificates` context.
  """

  @doc """
  Generate a certificate.
  """
  def certificate_fixture(attrs \\ %{}) do
    {:ok, certificate} =
      attrs
      |> Enum.into(%{

      })
      |> Expki.Certificates.create_certificate()

    certificate
  end
end
