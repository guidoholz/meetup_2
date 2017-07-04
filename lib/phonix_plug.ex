defmodule Phonix.Plug do
  use Plug.Builder

  plug Plug.Logger
  plug Phonix.Checker
  plug :hello

  @spec hello(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def hello(%Plug.Conn{request_path: "/"<>name } = conn, _opts) do
    conn
    |> send_resp(200, "my name is: #{name}")
  end

end
