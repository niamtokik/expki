defmodule Expki.Repo.Migrations.PkiInitiazation do
  use Ecto.Migration

  def change do
    # This table will contain all the keys, including the one
    # protected with encryption. For now, no information are
    # stored, only the raw key in PEM format.
    create table("keys") do
      add :key, :text, unique: true

      # TODO: define if the key is protected or not
      # add :encrypted, :boolean, default: false, null: false
      
      # TODO: parameters of the keys (e.g. size for rsa), it
      # will be useful to know it.
      # add :parameters, :text
      timestamps()
    end

    # This table will contain all certificates, including CA, CSR
    # and Signed Certificates.
    create table("certificates") do
      # the unique name of the certificate defined by the user
      add :name, :text, unique: true, null: false

      # the kind of certificate (csr, ca, signed...)
      add :is_request, :boolean, null: false
      add :is_ca, :boolean, null: false
      add :is_signed, :boolean, null: false

      # the certificate itself, in PEM format
      add :certificate, :text, unique: true, null: false

      # a certificate can have a key.
      add :key_id, references("keys")

      # The unique serial extracted from the certificate
      add :serial, :text, unique: true, null: false

      # the time interval extracted from the certificate.
      add :not_before, :timestamp, null: false
      add :not_after, :timestamp, null: false

      # TODO: the description of the certificate given by the user
      # add :description, :text

      # TODO: the version of the certificate used
      # add :version, :integer, default: 0, null: false

      # TODO: the status of the certificate
      # add :status, :text

      # TODO: the date of revokation, by default set to null.
      # add :revoked_at, :timestamp

      # TODO: the filename if any
      # add :filename, :text
      
      # TODO: The subject string from the certificate
      # add :subject, :text

      # TODO: a certificate can be signed by another certificate
      # present in the database. 
      # add :signed_by, references("certificates")
      
      timestamps()
    end
  end
end
