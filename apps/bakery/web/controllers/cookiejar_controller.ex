defmodule Bakery.CookiejarController do
  use Bakery.Web, :controller

  def show(conn, _opts) do
    conn |> render "show.html"
  end
end
