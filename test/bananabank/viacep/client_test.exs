defmodule Bananabank.Viacep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.Viacep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      cep = "37900138"

      body = ~s({
        "bairro": "Centro",
        "cep": "37900-138",
        "complemento": "de 130/131 a 141/142",
        "ddd": "35",
        "estado": "Minas Gerais",
        "gia": "",
        "ibge": "3147907",
        "localidade": "Passos",
        "logradouro": "Rua Gonçalves Dias",
        "regiao": "Sudeste",
        "siafi": "4957",
        "uf": "MG",
        "unidade": ""
      })

      expected_response = {:ok, %{"bairro" => "Centro", "cep" => "37900-138", "complemento" => "de 130/131 a 141/142", "ddd" => "35", "estado" => "Minas Gerais", "gia" => "", "ibge" => "3147907", "localidade" => "Passos", "logradouro" => "Rua Gonçalves Dias", "regiao" => "Sudeste", "siafi" => "4957", "uf" => "MG", "unidade" => ""}}

      Bypass.expect(bypass, "GET", "/37900138/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
