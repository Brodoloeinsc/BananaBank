defmodule BananaBank.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  # To run the migrations use `mix ecto.migrate`

  # Change Create and Delete the things, but you can use the functions UP and DOWN

  def change do
    # Creating the table Users at my database banana_bank
    create table("users") do
      # Here I added the user's fields

      add :name, :string, null: false
      # Saving the hash of the password to prevent data leak
      add :password_hash, :string, null: false
      add :email, :string, null: false
      add :cep, :string, null: false

      timestamps()
    end
  end
end
