defmodule PasswordGeneratorWebWeb.PageController do
  use PasswordGeneratorWebWeb, :controller

  def index(conn, _params) do
    password_lengths = [
      Faible: Enum.map(6..15, & &1),
      Fiable: Enum.map(16..88, & &1),
      Impossible: [100, 150]
    ]

    password = ""

    render(
      conn,
      "index.html",
      password_length: password_lengths,
      password: password
    )
  end
end
