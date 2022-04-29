defmodule PasswordGeneratorWeb.Repo do
  use Ecto.Repo,
    otp_app: :password_generator_web,
    adapter: Ecto.Adapters.Postgres
end
