defmodule Expki.Keys do
  import Ecto.Query, warn: false
  alias Expki.Repo
  alias Expki.Certificates.Key

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
  def generate_key(params \\ %{}) do
    modulus = Map.get(params, :modulus, 2048)
    exponent = Map.get(params, :exponent, 65537)

    # different methods exists to generate a private key, the one
    # from crypto will output a private key as binaries, then it will
    # need to be converted. instead, generate_key from public_key
    # module is directly compatible with the pem format.
    private_key = :public_key.generate_key({:rsa, modulus, exponent})

    # generate the pem entry for an RSA Private Key
    # TODO: add encryption support
    pem_entry = :public_key.pem_entry_encode(:"RSAPrivateKey", private_key)

    # encode the pem entry previously created
    :public_key.pem_encode([pem_entry])
  end

  @doc """
  Verify if a key is correct and uses a valid pem format.

  TODO: use this function in a changeset
  """
  @spec verify_key(key :: String.t()) :: :ok | {:error, term()}
  def verify_key(key) do
    key
    |> :public_key.pem_decode()
    |> verify_key1()
  end

  # it must have only one pem entry.
  defp verify_key1(pem_entry = [{:"RSAPrivateKey", _pkey, :not_encrypted}]) do
    pem_entry
    |> verify_key2()
  end
  defp verify_key1(_), do: {:error, :pem}

  # check the RSAPrivateKey Erlang record
  defp verify_key2([rsa = {:"RSAPrivateKey", _, _}]) do
    rsa
    |> :public_key.pem_entry_decode()
    |> verify_key3()
  end
  defp verify_key2(_), do: {:error, :pem_entry}

  # check the decoded content of the RSA private key
  # TODO: check each fields.
  defp verify_key3({:RSAPrivateKey, _v, _, _, _, _, _, _, _, _, _}), do: :ok
  defp verify_key3(_), do: {:error, :rsa_private_key}

  @doc """
  Create a new key and insert it in the database after
  validation. If no key is given, a key is generated
  automatically via generate_key/0.

  TODO: the verification should be done in a changeset
  """
  def create_key(attrs \\ %{}) do
    key = Map.get(attrs, :key, generate_key())
    case verify_key(key) do
      :ok -> Repo.insert(%Key{ key: key })
      error -> error
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
