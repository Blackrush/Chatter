defmodule Chatter.SessionControllerTest do
  use Chatter.ConnCase

  alias Chatter.User

  @login "test@test"
  @password "test"

  setup %{conn: conn} do
    %User{}
    |> User.changeset(%{"login" => @login, "password" => @password, "password_confirmation" => @password})
    |> Repo.insert!

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "successful auth", %{conn: conn} do
    resp = post(conn, "/sessions", %{"session" => %{"login" => @login, "password" => @password}})
    assert resp.status == 200

    body = Poison.decode!(resp.resp_body)
    assert is_binary(body["token"])
  end

  test "login not found", %{conn: conn} do
    resp = post(conn, "/sessions", %{"session" => %{"login" => "invalid", "password" => "invalid"}})
    assert resp.status == 404
    assert resp.resp_body =~ "login or password not found"
  end

  test "password invalid", %{conn: conn} do
    resp = post(conn, "/sessions", %{"session" => %{"login" => @login, "password" => "invalid"}})
    assert resp.status == 404
    assert resp.resp_body =~ "login or password not found"
  end
end
