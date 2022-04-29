defmodule PasswordGeneratorWebWeb.PageController do
  use PasswordGeneratorWebWeb, :controller

  def index(conn, _params, password_lengths) do
    password = ""

    render(
      conn,
      "index.html",
      password_length: password_lengths,
      password: password
    )
  end

  def generate(conn, %{"password" => password_params}, password_lengths) do
    {:ok, password} = PasswordGen.generate(password_params)

    render(
      conn,
      "index.html",
      password_length: password_lengths,
      password: password
    )
  end

  def action(conn, _) do
    password_lengths = [
      Faible: Enum.map(6..15, & &1),
      Fiable: Enum.map(16..88, & &1),
      Impossible: [100, 150]
    ]

    args = [conn, conn.params, password_lengths]
    apply(__MODULE__, action_name(conn), args)
  end
end
