defmodule Expki.KeysTest do
  use Expki.DataCase
  alias Expki.PublicKeyFixtures

  describe "keys" do
    alias Expki.Certificates.Key
    alias Expki.Keys

    # TODO: create fixtures
    # import Expki.KeysFixtures

    # TODO: define invalid attributes
    # @invalid_attrs %{}

    test "list_keys/0 returns nothing" do
      assert Keys.list_keys() == []
    end

    test "verify if a private key is valid from a file" do
      assert({:ok, _} =
        PublicKeyFixtures.local_certificate_authority_file("ca.key.pem")
        |> Keys.verify_private_key())
    end

    test "insert a new privatekey from a file" do
      {:ok, pkey = %Key{}} = Keys.create_private_key(%{
          key: PublicKeyFixtures.local_certificate_authority_file("ca.key.pem") 
        })
      assert(^pkey = Keys.get_key(pkey.id))
    end

  end
end
