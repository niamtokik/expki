defmodule Expki.PublicKey.CertificateAlgorithmIdentifier do
  use Expki.PublicKey, name: :Certificate_algorithmIdentifier
  alias Expki.PublicKey

  @algorithms [
    :sha224WithRSAEncryption,
    :sha256WithRSAEncryption,
    :sha384WithRSAEncryption,
    :sha512WithRSAEncryption
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
