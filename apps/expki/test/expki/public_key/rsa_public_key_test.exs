defmodule Expki.PublicKey.RSAPublicKeyTest do
  use Expki.DataCase

  describe "Erlang public_key RSAPublicKey record support" do
    alias Expki.PublicKey.RSAPublicKey

    test "RSAPublicKey record to struct" do
      assert({:ok, %RSAPublicKey{}} =
        {:RSAPublicKey, :undefined, :undefined}
        |> RSAPublicKey.convert())

      assert({:ok, {:RSAPublicKey, :undefined, :undefined}} =
        %RSAPublicKey{}
        |> RSAPublicKey.convert())
    end
  end
end
