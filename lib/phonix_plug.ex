defmodule Phonix.Plug do
  use Plug.Builder

  plug Plug.Logger
  plug Phonix.Checker
  plug :hello

  @spec hello(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def hello(%Plug.Conn{request_path: "/"<>ext } = conn, _opts) do
    conn
    |> send_resp(200, "my extension is: #{ext}")
  end

end
