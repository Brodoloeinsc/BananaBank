Mox.defmock(BananaBank.Viacep.ClientMock, for: BananaBank.Viacep.ClientBehaviour)
Application.put_env(:bananabank, :via_cep_client, BananaBank.Viacep.ClientMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BananaBank.Repo, :manual)
