defmodule BananaBankWeb.UsersControllerTest do
  # Serve para nao alterar definitivamente um database nem afetar outros testes as modificaçoes temporarias
  use BananaBankWeb.ConnCase

  import Mox

  setup :verify_on_exit!

  alias BananaBank.Users
  alias BananaBank.Users.User

  setup do
    params = %{
      "name" => "Rafael",
      "cep" => "37900138",
      "email" => "rafael@gmail.com",
      "password" => "eqrr198y1412y4i1hwr819"
    }

    body = %{
      "bairro" => "Centro",
      "cep" => "37900-138",
      "complemento" => "de 130/131 a 141/142",
      "ddd" => "35",
      "estado" => "Minas Gerais",
      "gia" => "",
      "ibge" => "3147907",
      "localidade" => "Passos",
      "logradouro" => "Rua Gonçalves Dias",
      "regiao" => "Sudeste",
      "siafi" => "4957",
      "uf" => "MG",
      "unidade" => ""
    }

    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "successfully create an user", %{conn: conn, body: body, user_params: params} do

      expect(BananaBank.Viacep.ClientMock, :call, fn "37900138" ->
        {:ok, body}
      end)

      response =
        conn
        # Phoenix 1.6 => Routes.users_path(conn, :create)
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
        "data" => %{"cep" => "37900138", "email" => "rafael@gmail.com", "id" => _id, "name" => "Rafael"}, "message" => "User created successfully"
      } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do

      params = %{
        cep: "3790",
        email: "rafael@gmail.com",
        password: "1"
      }

      expect(BananaBank.Viacep.ClientMock, :call, fn "3790" ->
        {:ok, ""}
      end)

      response =
        conn
        # Phoenix 1.6 => Routes.users_path(conn, :create)
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response =%{
        "errors" => %{
          "cep" => ["should be 8 character(s)"],
          "password" => ["should be at least 7 character(s)"],
          "name" => ["can't be blank"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully delete an user", %{conn: conn, body: body, user_params: params} do

      expect(BananaBank.Viacep.ClientMock, :call, fn "37900138" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => "37900138", "email" => "rafael@gmail.com", "id" => id, "name" => "Rafael"}, "message" => "User deleted successfully"
      }

      assert response == expected_response
    end

    test "when there are no id at the url, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(~p"/api/users/")
        |> json_response(:not_found)

      expected_response = %{"errors" => %{"detail" => "Not Found"}}

      assert response == expected_response
    end
  end

  describe "show/2" do
    test "successfully get an user", %{conn: conn, body: body, user_params: params} do

      expect(BananaBank.Viacep.ClientMock, :call, fn "37900138" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> get(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => "37900138", "email" => "rafael@gmail.com", "id" => id, "name" => "Rafael"}
      }

      assert response == expected_response
    end

    test "when there are no id at the url, returns an error", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/users/")
        |> json_response(:not_found)

      expected_response = %{"errors" => %{"detail" => "Not Found"}}

      assert response == expected_response
    end
  end

  describe "update/2" do
    test "successfully update an user", %{conn: conn, body: body, user_params: params} do

      expect(BananaBank.Viacep.ClientMock, :call, fn "37900138" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> put(~p"/api/users/#{id}", params)
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "cep" => "37900138",
          "email" => "rafael@gmail.com",
          "id" => id,
          "name" => "Rafael"
        },
        "message" => "User updated successfully"
      }

      assert response == expected_response
    end

    test "when there are no id at the url, returns an error", %{conn: conn, user_params: params} do
      response =
        conn
        |> put(~p"/api/users/", params)
        |> json_response(:not_found)

      expected_response = %{"errors" => %{"detail" => "Not Found"}}

      assert response == expected_response
    end
  end

end
