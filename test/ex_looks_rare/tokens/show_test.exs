defmodule ExLooksRare.Tokens.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExLooksRare.Tokens.Show

  # goblintown.wtf
  @contract_address "0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e"

  defmodule ErrorAdapter do
    def send(_request) do
      {:error, :from_adapter}
    end
  end

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1 returns the token details" do
    use_cassette "tokens/show/get_ok" do
      assert {:ok, token} = ExLooksRare.Tokens.Show.get(@contract_address, 1)
      assert %ExLooksRare.Token{} = token
      assert token.collection_address != nil
      assert token.token_uri != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_looks_rare: [adapter: ErrorAdapter]] do
      assert ExLooksRare.Tokens.Show.get(@contract_address, 1) == {:error, :from_adapter}
    end
  end
end
