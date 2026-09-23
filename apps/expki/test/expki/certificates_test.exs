defmodule Expki.CertificatesTest do
  use Expki.DataCase

  alias Expki.Certificates

  describe "certificates" do
    alias Expki.Certificates.Certificate

    import Expki.CertificatesFixtures

    @invalid_attrs %{}

    test "list_certificates/0 returns all certificates" do
      certificate = certificate_fixture()
      assert Certificates.list_certificates() == [certificate]
    end

    test "get_certificate!/1 returns the certificate with given id" do
      certificate = certificate_fixture()
      assert Certificates.get_certificate!(certificate.id) == certificate
    end

    test "create_certificate/1 with valid data creates a certificate" do
      valid_attrs = %{}

      assert {:ok, %Certificate{} = certificate} = Certificates.create_certificate(valid_attrs)
    end

    test "create_certificate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Certificates.create_certificate(@invalid_attrs)
    end

    test "update_certificate/2 with valid data updates the certificate" do
      certificate = certificate_fixture()
      update_attrs = %{}

      assert {:ok, %Certificate{} = certificate} = Certificates.update_certificate(certificate, update_attrs)
    end

    test "update_certificate/2 with invalid data returns error changeset" do
      certificate = certificate_fixture()
      assert {:error, %Ecto.Changeset{}} = Certificates.update_certificate(certificate, @invalid_attrs)
      assert certificate == Certificates.get_certificate!(certificate.id)
    end

    test "delete_certificate/1 deletes the certificate" do
      certificate = certificate_fixture()
      assert {:ok, %Certificate{}} = Certificates.delete_certificate(certificate)
      assert_raise Ecto.NoResultsError, fn -> Certificates.get_certificate!(certificate.id) end
    end

    test "change_certificate/1 returns a certificate changeset" do
      certificate = certificate_fixture()
      assert %Ecto.Changeset{} = Certificates.change_certificate(certificate)
    end
  end
end
