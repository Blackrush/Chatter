defmodule Chatter.Repo do
  use Ecto.Repo, otp_app: :chatter
  use Scrivener, page_size: 10
end
