defmodule Chatter.User do
  use Chatter.Web, :model
  @derive {Poison.Encoder, only: [:id, :name]}

  schema "users" do
    field :name, :string

    field :login, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :login, :password, :password_confirmation])
    |> validate_format(:login, ~r/@/)
    |> validate_confirmation(:password, message: "does not match password")
    |> encrypt_password()
    |> unique_constraint(:name)
    |> unique_constraint(:login)
  end

  def encrypt_password(changeset = %{valid?: true}) do
    case fetch_change(changeset, :password) do
      :error -> changeset

      {:ok, password} ->
        salt = SecureRandom.urlsafe_base64(32)
        hash = hash_password(password, salt)
        password_hash = "#{hash}%#{salt}"

        change(changeset, password_hash: password_hash)
    end
  end

  def encrypt_password(x), do: x

  def valid_password?(user, password) do
    [hash, salt] = String.split(user.password_hash, "%", parts: 2)
    valid_password?(password, hash, salt)
  end

  def valid_password?(password, hash, salt) do
    hash == hash_password(password, salt)
  end

  def hash(text) do
    :crypto.hash(:sha256, text)
    |> Base.encode16
  end

  def hash_password(password, salt) do
    hash([hash(password), salt])
  end
end
