defmodule Bakery.Router do
  use Bakery.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Bakery.BakeIt
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Bakery do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/cookiejar", CookiejarController, :show
    post "/cookiejar", CookiejarController, :show

  end

  # Other scopes may use custom stacks.
  # scope "/api", Bakery do
  #   pipe_through :api
  # end
end
