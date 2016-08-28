defmodule Chatter.UserView do
  use Chatter.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, Chatter.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Chatter.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    user
  end
end
