defmodule Expki.Repo do
  use Ecto.Repo,
    otp_app: :expki,
    adapter: Ecto.Adapters.Postgres
end
