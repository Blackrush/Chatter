defmodule Chatter.SessionController do
  use Chatter.Web, :controller

  alias Chatter.User

  def create(conn, %{"session" => %{"login" => login, "password" => password}}) do
    case Repo.get_by(User, login: login) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"error" => "login or password not found"})
      user ->
        if User.valid_password?(user, password) do
          token = Phoenix.Token.sign(conn, "user", user.id)

          conn
          |> put_status(:ok)
          |> json(%{"token" => token})
        else
          conn
          |> put_status(:not_found)
          |> json(%{"error" => "login or password not found"})
        end
    end
  end
end
