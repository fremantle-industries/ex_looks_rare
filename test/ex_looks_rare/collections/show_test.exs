defmodule ExLooksRare.Collections.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExLooksRare.Collections.Show

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

  test ".get/1" do
    use_cassette "collections/show/get_ok" do
      assert {:ok, collection} = ExLooksRare.Collections.Show.get(@contract_address)
      assert %ExLooksRare.Collection{} = collection
      assert collection.name != nil
      assert collection.is_verified != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_looks_rare: [adapter: ErrorAdapter]] do
      assert ExLooksRare.Collections.Show.get(@contract_address) == {:error, :from_adapter}
    end
  end
end
