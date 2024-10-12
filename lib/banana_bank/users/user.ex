defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  # Schema de cadastro da tabela usuarios
  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :email, :string
    field :cep, :string

    timestamps()
  end


  # Changeset de cadastro da tabela usuarios
  # Changeset = Conjunto de mudanças
  def changeset(user \\%__MODULE__{}, params) do
    user
    |> cast(params, [:name, :password_hash, :email, :cep])
    |> validate_required([:name, :password_hash, :email, :cep])
  end

end
