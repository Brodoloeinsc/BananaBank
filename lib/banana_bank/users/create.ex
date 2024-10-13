defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.Viacep.Client, as: ViaCepClient

  def call(%{"cep" => cep} = params) do
    with {:ok, _result} <- client().call(cep) do
      params
      |> User.changeset()
      |> Repo.insert
    end
  end

  defp client() do
    Application.get_env(:bananabank, :via_cep_client, ViaCepClient)
  end
end
