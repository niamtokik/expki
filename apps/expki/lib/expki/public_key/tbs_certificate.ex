defmodule Expki.PublicKey.TBSCertificate do
  use Expki.PublicKey, record_id: :TBSCertificate
  alias Expki.PublicKey.TBSCertificateSignature
  alias Expki.PublicKey.Validity
  alias Expki.PublicKey.SubjectPublicKeyInfo
  alias Expki.PublicKey.CertificateAlgorithmIdentifier
  alias Expki.PublicKey.AttributeTypeAndValue

  def t() do
    %__MODULE__{
      version: :todo,
      serialNumber: :todo,
      signature: %TBSCertificateSignature{
        algorithm: {1,2,840,113549,1,1,11},
        parameters: {:asn1_OPENTYPE,<<5,0>>}
      },
      issuer: {:rdnSequence, [
        [AttributeTypeAndValue.id_at_countryName(~c"CF")],
        [AttributeTypeAndValue.id_at_organizationName("OrganizationName")],
        [AttributeTypeAndValue.id_at_organizationalUnitName("OrganizationUnit")],
        [AttributeTypeAndValue.id_at_stateOrProvinceName("State")],
        [AttributeTypeAndValue.id_at_commonName("CommonName")],
        [AttributeTypeAndValue.id_at_serialNumber("SerialNumber")],
      ]},
      validity: Validity.create(
        ~U[2020-01-01 00:00:00Z],
        ~U[2030-01-01 00:00:00Z]
      ),
      subject: {:rdnSequence, [
        [AttributeTypeAndValue.id_at_countryName(~c"CF")],
        [AttributeTypeAndValue.id_at_organizationName("OrganizationName")],
        [AttributeTypeAndValue.id_at_organizationalUnitName("OrganizationUnit")],
        [AttributeTypeAndValue.id_at_stateOrProvinceName("State")],
        [AttributeTypeAndValue.id_at_commonName("CommonName")],
        [AttributeTypeAndValue.id_at_serialNumber("SerialNumber")],
      ]},
      subjectPublicKeyInfo: %SubjectPublicKeyInfo{
        algorithm: %CertificateAlgorithmIdentifier{
        },
        subjectPublicKey: "",
      },
      issuerUniqueID: :asn1_NOVALUE,
      subjectUniqueID: :asn1_NOVALUE,
      extensions: :asn1_NOVALUE,
    }
  end

end
