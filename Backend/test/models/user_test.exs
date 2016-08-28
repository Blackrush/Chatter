defmodule Chatter.UserTest do
  use Chatter.ModelCase

  alias Chatter.User

  @valid_attrs %{login: "some@email", name: "some content", password: "some content", password_confirmation: "some content"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "password validation" do
    assert User.valid_password?("test", "6BFFCF6EC5AF7606E42B1E112FA1D422A9392FB84CFC592B7B5416E098D5AD0B", "test")
    refute User.valid_password?("test", "8B997FF0D575CF7BC64F11B1FC6F9FEA376A8BB54A65DA4AE94B9662D067D7AA", "test")
    refute User.valid_password?("test", "0C2DC02C710AC4701355767E66E6D28842DB9424D0FD97FA1FF204D86C86F141", "test")
  end

  test "valid password changeset" do
    changeset = User.changeset(%User{}, %{"password" => "test", "password_confirmation" => "test"})
    assert changeset.valid?
    assert changeset.changes[:password_hash]
  end

  test "invalid password changeset" do
    changeset = User.changeset(%User{}, %{"password" => "different", "password_confirmation" => "test"})
    refute changeset.valid?
    refute changeset.changes[:password_hash]
  end
end
