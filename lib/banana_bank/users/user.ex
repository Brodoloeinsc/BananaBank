defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:name, :password, :email, :cep]
  @required_params_update [:name, :email, :cep]

  # Only, Except, precisa tirar o __meta caso use o except
  # @derive {Jason.Encoder, only: [:name]} -> Para ser o model de renderizar o JSON

  # Schema de cadastro da tabela usuarios
  schema "users" do
    field :name, :string
    # This field password, only exists at the logic part of the code
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :cep, :string

    timestamps()
  end

  # Esse o o changeset default, caso a struct nao seja vazia Changeset do Update
  # def changeset(user \\%__MODULE__{}, params)

  # Caso a struct seja vazia ele na verdade executa essa funçao Changeset do Create
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> do_validation(@required_params_create)
    |> add_password_hash()
  end

  # Changeset de cadastro da tabela usuarios
  # Changeset = Conjunto de mudanças
  def changeset(user, params) do
    user
    |> cast(params, @required_params_create)
    |> do_validation(@required_params_update)
    |> add_password_hash()
  end

  #
  defp do_validation(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cep, is: 8)
    |> validate_length(:password, min: 7)
  end

  defp add_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Pbkdf2.hash_pwd_salt(password))
  end

  defp add_password_hash(changeset), do: changeset

end
