defmodule Expki.Keys do
  @moduledoc """
  This module is in charge to deal with the public and private
  keys, at this time, only RSA keys are supported.

  TODO: generating RSA key >1024 bits can have a huge impact on the
  performance of the application and should be isolated in its own
  process.

  TODO: what about entropy? I currently don't know how the crypto
  and public_key modules offered by Erlang/OTP are dealing with
  that.

  """
  import Ecto.Query, warn: false
  alias Expki.Repo
  alias Expki.Certificates.Key
  alias Expki.PublicKey.RSAPrivateKey
  alias Expki.PublicKey.RSAPublicKey

  @doc """
  List all keys present in the keys table.
  """
  def list_keys do
    Repo.all(Key)
  end

  @doc """
  Generate a new private rsa key.

  see: https://www.erlang.org/doc/apps/crypto/crypto.html#t:rsa_params/0
  see: https://www.erlang.org/doc/apps/public_key/public_key.html#generate_key/1
  see: https://github.com/erlang/otp/blob/c845375d0f26e65688237de8edb730f57f1f3697/lib/public_key/doc/guides/using_public_key.md
  """
  @spec generate_private_key(params :: Map.t()) :: {:ok, String.t()}
  def generate_private_key(params \\ %{}) do
    modulus = Map.get(params, :modulus, 2048)
    exponent = Map.get(params, :exponent, 65537)

    # different methods exists to generate a private key, the one
    # from crypto will output a private key as binaries, then it will
    # need to be converted. instead, generate_key from public_key
    # module is directly compatible with the pem format.
    private_key = :public_key.generate_key({:rsa, modulus, exponent})

    # generate the pem entry for an RSA Private Key
    # TODO: add encryption support
    pem_entry = :public_key.pem_entry_encode(:RSAPrivateKey, private_key)

    # encode the pem entry previously created
    {:ok, :public_key.pem_encode([pem_entry])}
  end

  @doc """
  Verify if a key is correct and uses a valid pem format.

  TODO: use this function in a changeset
  """
  @spec verify_private_key(key :: String.t()) :: :ok | {:error, term()}
  def verify_private_key(key) do
    with [pem_entry = {:RSAPrivateKey, _,_}] <- :public_key.pem_decode(key),
      {:ok, _} <- RSAPrivateKey.convert(:public_key.pem_entry_decode(pem_entry))
    do
      :ok
    else
      _ -> {:error, :invalid_key}
    end
  end

  @doc """
  check if a key is a supported private key. only RSA
  private key is currently supported in PEM format.
  """
  @spec private_key?(key :: String.t()) :: boolean()
  def private_key?(key) do
    case verify_private_key(key) do
      :ok -> true
      _ -> false
    end
  end

  @doc """
  Create a new key and insert it in the database after
  validation. If no key is given, a key is generated
  automatically via generate_key/0.

  TODO: the verification should be done in a changeset
  """
  def create_private_key(attrs \\ %{}) do
    key = Map.get(attrs, :key, generate_private_key())
    case verify_private_key(key) do
      :ok -> Repo.insert(%Key{ key: key })
      error -> error
    end
  end

  @doc """
  return the public key in PEM format.

  TODO: public key should also be stored in the database
  alongside the private key (speed up)
  """
  def public_key_from_private_key(key) do
    with [pem_entry = {:RSAPrivateKey, _,_}] <- :public_key.pem_decode(key),
      {:ok, %RSAPrivateKey{modulus: modulus, publicExponent: exponent}} <- RSAPrivateKey.convert(:public_key.pem_entry_decode(pem_entry))
    do
      pem_entry = 
        %RSAPublicKey{ modulus: modulus, publicExponent: exponent }
        |> RSAPublicKey.pem_entry_encode!()
      {:ok, :public_key.pem_encode(pem_entry)}
    else
      _ -> {:error, :not_private_key}
    end
  end

  @doc """
  Returns a key from the database.
  """
  def get_key(id) do
    Repo.get_by(Key, id: id)
  end

  @doc """
  Delete a key from the database
  """
  def delete_key(key = %Key{}) do
    Repo.delete(key)
  end

end
