defmodule Expki.Keys do
  import Ecto.Query, warn: false
  alias Expki.Repo
  alias Expki.Certificates.Key

  @doc """
  List all keys present in the keys table.

  ## Example

  ```elixir
  iex> list_keys()
  []
  ```
  """
  def list_keys do
    Repo.all(Key)
  end

  def create_key() do
    create_key(generate_key())
  end

  def create_key(key) do
    Repo.insert(%Key{ key: key })
  end

  @doc """
  Generate a new private rsa key.

  see: https://www.erlang.org/doc/apps/crypto/crypto.html#t:rsa_params/0
  see: https://www.erlang.org/doc/apps/public_key/public_key.html#generate_key/1
  see: https://github.com/erlang/otp/blob/c845375d0f26e65688237de8edb730f57f1f3697/lib/public_key/doc/guides/using_public_key.md
  """
  def generate_key() do
    private_key = :public_key.generate_key({:rsa, 1024, 65537}) #, pss_params()}
    pem_entry = :public_key.pem_entry_encode(:"RSAPrivateKey", private_key)
    :public_key.pem_encode([pem_entry])
  end

  @doc """
  TODO: to remove, not used, mostly reverse engineering test from erlang.
  """
  def generate_key2() do
    {public, private} = :crypto.generate_key(:rsa, {2048, 65537})
    :io.format("~p~n", [private])
    [public_exponent, public_modulus] = public
    [ _public_exponent, _public_modulus,
      private_exponent, prime1,
      prime2, exponent1,
      exponent2, crt
    ] = private
    private_key_record = {:RSAPrivateKey, 1, public_modulus, public_exponent, private_exponent, prime1, prime2, exponent1, exponent2, crt, []}
    private_key_params = pss_params()
    :public_key.der_encode(:PrivateKeyInfo, {private_key_record, private_key_params})
  end

  @doc """
  TODO: to remove, not used, mostly reverse engineering test from erlang.
  see: https://github.com/erlang/otp/blob/c845375d0f26e65688237de8edb730f57f1f3697/lib/public_key/doc/guides/public_key_records.md?plain=1#L118
  see: https://github.com/erlang/otp/blob/c845375d0f26e65688237de8edb730f57f1f3697/lib/public_key/test/public_key_SUITE.erl
  see: https://github.com/erlang/otp/blob/c845375d0f26e65688237de8edb730f57f1f3697/lib/public_key/include/OTP-PUB-KEY.hrl
  """
  def pss_params() do
    { :"RSASSA-PSS-params", 
      # hashAlgorithm
      {:HashAlgorithm, {2,16,840,1,101,3,4,2,1}},
      # maskGenAlgorithm
      {:MaskGenAlgorithm, :"id-mgf1", {:"HashAlgorithm", {2,16,840,1,101,3,4,2,1}}},
      # saltLength
      32,
      # trailerField
      1
    }
  end

end
