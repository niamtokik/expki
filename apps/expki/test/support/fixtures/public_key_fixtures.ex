defmodule Expki.PublicKeyFixtures do
  def local_key_file(name) do
    Path.join([__DIR__, "support", "fixtures", "keys", name])
    |> File.read!()
  end

  def local_certificate_authority_file(name) do
    Path.join([__DIR__, "certificate_authority", name])
    |> File.read!()
  end

  def local_certificate_file(name) do
    Path.join([__DIR__, "certificate", name])
    |> File.read!()
  end

  def local_certificate_signing_request(name) do
    Path.join([__DIR__, "certificate_signing_request", name])
    |> File.read!()
  end
end
