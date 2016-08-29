defmodule Chatter.Router do
  use Chatter.Web, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :secure_browser do
    plug Chatter.Plugs.HttpBasic
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Chatter do
    pipe_through :api

    resources "/users", UserController
    post "/sessions", SessionController, :create
  end

  scope "/admin", ExAdmin do
    pipe_through [:browser, :secure_browser]

    admin_routes
  end
end
