defmodule Twitter.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uname, :string
      add :passwd_hash, :string

      timestamps()
    end

    create unique_index(:users, [:uname])
  end
end
