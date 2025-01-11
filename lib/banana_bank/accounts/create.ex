defmodule BananaBank.Accounts.Create do
  alias BananaBank.Accounts.Account
  alias BananaBank.Repo

  def call(params) do
    # with {:ok, User} <- Users.get(id) do

    # end
    params
    |> Account.changeset()
    |> Repo.insert
  end
end
