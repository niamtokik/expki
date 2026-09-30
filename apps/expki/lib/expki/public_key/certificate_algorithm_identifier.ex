defmodule Expki.PublicKey.CertificateAlgorithmIdentifier do
  use Expki.PublicKey, record_id: :Certificate_algorithmIdentifier

  @algorithms [
    :md2WithRSAEncryption,
    :md5WithRSAEncryption,
    :sha1WithRSAEncryption,
    :sha224WithRSAEncryption,
    :sha256WithRSAEncryption,
    :sha384WithRSAEncryption,
    :sha512WithRSAEncryption,
  ]

  for algorithm <- @algorithms do
    def unquote(algorithm)(params) do
      %__MODULE__{
        algorithm: PublicKey.macro(unquote(algorithm)),
        parameters: params
      }
    end
  end
end
