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
    |> passwd_changeset
  end

  defp passwd_changeset(changeset) do
    case changeset do
    %Ecto.Changeset{valid?: true, changes: %{passwd: passwd}}
    ->
        put_change(changeset, :passwd_hash, Bcrypt.hash_pwd_salt(passwd))
    _
    ->
        changeset
    end
  end

end
