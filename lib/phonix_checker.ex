defmodule Phonix.Checker do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/" <> ext } = conn, _opts) do
    case Enum.member?(["User", "Users"], ext) do
      true ->
        conn
      false ->
          conn
        |> send_resp(404, "SOMETHNG WENT WRONG")
        |> halt
    end
  end

end
