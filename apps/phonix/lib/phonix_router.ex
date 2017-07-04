defmodule Phonix.Router do
  use Plug.Router

  plug :match
  plug :dispatch
  plug Phonix.Plug

  get "/" do
    send_resp(conn, 200, "root-path and nothing to do here!")
  end

  get "/:name", do: conn

  match _ do
    send_resp(conn, 404, "oops")
  end

end
