defmodule Twitter.Accounts do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :passwd_hash, :string
    field :passwd, :string, virtual: true
    field :uname, :string

    timestamps()
  end

  @doc false
  def changeset(accounts, attrs) do
    accounts
    |> cast(attrs, [:uname, :passwd_hash, :passwd])
    |> validate_required([:uname, :passwd])
    |> unique_constraint(:uname)
    |> put_passwd
  end

  defp put_passwd(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{passwd: passwd}}
      ->
        hashed=:crypto.hash(:sha256, passwd)
               |>Base.encode16
        put_change(changeset, :passwd_hash, hashed)
      _
      ->
        changeset
    end
  end

end
