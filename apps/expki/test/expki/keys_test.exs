defmodule Expki.KeysTest do
  use Expki.DataCase
  alias Expki.Keys

  describe "keys" do
    alias Expki.Certificates.Key

    # TODO: create fixtures
    # import Expki.KeysFixtures

    # TODO: define invalid attributes
    @invalid_attrs %{}

    test "list_keys/0 returns all keys" do
      assert Keys.list_keys == []
    end
  end
end
