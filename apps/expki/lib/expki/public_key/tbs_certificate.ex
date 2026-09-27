defmodule Expki.PublicKey.TBSCertificate do
  use Expki.PublicKey, name: :TBSCertificate
  alias Expki.PublicKey.TBSCertificateSignature
  alias Expki.PublicKey.Validity
  alias Expki.PublicKey.SubjectPublicKeyInfo
  alias Expki.PublicKey.CertificateAlgorithmIdentifier
  alias Expki.PublicKey.AttributeTypeAndValue

# draft
#   def create(params) do
#     with version <- Map.get(params, :version),
#       serial_number <- Map.get(params, :serialNumber),
#       signature = %TBSCertificateSignature{} <- Map.get(params, :signature),
#       issuer <- Map.get(params, :issuer),
#       validity = %Validity{} <- Map.get(params, :validity),
#       subject <- Map.get(params, :subject),
#       subject_public_key_info = %SubjectPublicKeyInfo{} <- Map.get(params, :subjectPublicKeyInfo),
#       certificate_algorithm_identifier = %CertificateAlgorithmIdentifier{} <- Map.get(params, :issuerUniqueID),
#       subject_unique_id <- Map.get(params, :subjectUniqueID),
#       extension <- Map.get(params, :extensions)
#     do
#       %__MODULE__{
#         version: version,
#         serialNumber: serial_number,
#         signature: signature,
#         issuer: issuer,
#         validity: validity,
#         subject: subject,
#         subjectPublicKeyInfo: subject_public_key_info,
#         certificate_algorithm_identifier: certificate_algorithm_identifier,
#         issuerUniqueID: issuer_unique_id,
#         subjectUniqueID: subject_unique_id,
#         extension: extension
#       }
#     end
#   end

  def t() do
    %__MODULE__{
      issuer: {:rdnSequence, [
        [AttributeTypeAndValue.id_at_countryName(~c"CF")],
        [AttributeTypeAndValue.id_at_organizationName("OrganizationName")],
        [AttributeTypeAndValue.id_at_organizationalUnitName("OrganizationUnit")],
        [AttributeTypeAndValue.id_at_stateOrProvinceName("State")],
        [AttributeTypeAndValue.id_at_commonName("CommonName")],
        [AttributeTypeAndValue.id_at_serialNumber("SerialNumber")],
      ]},
      validity: Validity.create( ~U[2020-01-01 00:00:00Z], ~U[2030-01-01 00:00:00Z]),
    }
  end

end
