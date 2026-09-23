defmodule Expki.Repo.Migrations.PkiInitiazation do
  use Ecto.Migration

  def change do

    # this tablew will contain the keys used
    # to sign the certificates
    create table("keys") do
      add :key, :string, unique: true
      timestamps()
    end

    # this table will contain the diffie helman
    # parameters
    create table("dh_params") do
      add :param, :string, unique: true
      timestamps()
    end

    # this table will contain the CA in charge of
    # signing the certificates
    create table("certificates_authorities") do
      add :certificate, :string, unique: true, null: false
      add :key_id, references("keys"), null: false
      timestamps()
    end

    # this table will contain all certificate requests
    # used to generate the certificate
    create table("certificates_requests") do
      add :certificate, :string, unique: true, null: false
      timestamps()
    end

    # this table will contain all issued certificates
    # with their state.
    create table("certificates") do
      add :certificate, :string, unique: true, null: false
      add :serial, :string, unique: true, null: false
      add :status, :string
      add :expire_at, :timestamp
      add :revoked_at, :timestamp
      add :filename, :string
      add :subject, :string
      add :certificate_authority_id, references("certificates_authorities"), null: false
      add :certificate_requests_id, references("certificates_requests"), null: false
      timestamps()
    end
  end
end
