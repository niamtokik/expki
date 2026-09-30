defmodule Expki.PublicKey.Certificate do
  use Expki.PublicKey, record_id: :Certificate
  alias Expki.PublicKey.TBSCertificate
  alias Expki.PublicKey.CertificateAlgorithmIdentifier

  def t() do
    %__MODULE__{
      # just the example from TBSCertificate
      tbsCertificate: TBSCertificate.t(),
      signatureAlgorithm: %CertificateAlgorithmIdentifier{
        algorithm: :todo,
        parameters: :todo,
      },
      signature: :todo
    }
  end
end
