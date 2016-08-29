defmodule Chatter.Plugs.HttpBasic do
  import Plug.Conn

  alias Chatter.Repo
  alias Chatter.User

  def init(_opts) do
    []
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> authorization] ->
        [login, password] = String.split(Base.decode64!(authorization), ":", parts: 2)

        case Repo.get_by(User, login: login) do
          nil ->
            conn
            |> put_resp_header("www-authenticate", "Basic realm=\"Chatter\"")
            |> send_resp(401, "401 Unauthorized")
            |> halt

          user ->
            if User.valid_password?(user, password) do
              conn
              |> assign(:current_user, user)
            else
              conn
              |> put_resp_header("www-authenticate", "Basic realm=\"Chatter\"")
              |> send_resp(401, "401 Unauthorized")
              |> halt
            end
        end

      [] ->
        conn
        |> put_resp_header("www-authenticate", "Basic realm=\"Chatter\"")
        |> send_resp(401, "401 Unauthorized")
        |> halt
    end
  end
end
