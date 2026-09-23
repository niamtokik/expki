defmodule Expki.Repo.Migrations.PkiInitiazation do
  use Ecto.Migration

  def change do
    create table("keys") do
      add :key, :text, unique: true
      timestamps()
    end

    create table("dh_params") do
      add :param, :string, unique: true
      timestamps()
    end

    create table("certificates_authorities") do
      add :name, :string, unique: true, null: false
      add :description, :string
      add :certificate, :string, unique: true, null: false
      add :key_id, references("keys"), null: false
      timestamps()
    end

    create table("certificates_requests") do
      add :name, :string, unique: true, null: false
      add :description, :string
      add :certificate, :string, unique: true, null: false
      timestamps()
    end

    create table("certificates") do
      add :name, :string, unique: true, null: false
      add :description, :string
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
