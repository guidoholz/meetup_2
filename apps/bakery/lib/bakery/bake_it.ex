defmodule Bakery.BakeIt do
  import Plug.Conn

  def init(conn), do: conn

  def call(%Plug.Conn{body_params: %{"flavor" => flavor} } = conn, _opts) do
    case flavor do
      nil    -> conn
      flavor -> conn |> put_resp_cookie("flavor", flavor, http_only: false)
    end
    |> IO.inspect
  end

  def call(conn,_), do: conn

end
