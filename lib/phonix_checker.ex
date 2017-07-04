defmodule Phonix.Checker do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/" <> name } = conn, _opts) do
    case Enum.member?(["Niklas", "Guido"], name) do
      true ->
        conn
      false ->
          conn
        |> send_resp(404, "SOMETHNG WENT WRONG")
        |> halt
    end
  end

end
