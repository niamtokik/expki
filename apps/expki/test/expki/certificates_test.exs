defmodule Expki.CertificatesTest do
  use Expki.DataCase

  # alias Expki.Certificates

  describe "certificates" do
    # alias Expki.Certificates.Certificate

    # import Expki.CertificatesFixtures

    # @invalid_attrs %{}

# comment the tests for now, the certificate interface is not ready
# yet
#     test "list_certificates/0 returns all certificates" do
#       certificate = certificate_fixture()
#       assert Certificates.list_certificates() == [certificate]
#     end
# 
#     test "get_certificate!/1 returns the certificate with given id" do
#       certificate = certificate_fixture()
#       assert Certificates.get_certificate!(certificate.id) == certificate
#     end
# 
#     test "create_certificate/1 with valid data creates a certificate" do
#       valid_attrs = %{}
# 
#       assert {:ok, %Certificate{} = certificate} = Certificates.create_certificate(valid_attrs)
#     end
# 
#     test "create_certificate/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Certificates.create_certificate(@invalid_attrs)
#     end
# 
#     test "delete_certificate/1 deletes the certificate" do
#       certificate = certificate_fixture()
#       assert {:ok, %Certificate{}} = Certificates.delete_certificate(certificate)
#       assert_raise Ecto.NoResultsError, fn -> Certificates.get_certificate!(certificate.id) end
#     end
  end
end
