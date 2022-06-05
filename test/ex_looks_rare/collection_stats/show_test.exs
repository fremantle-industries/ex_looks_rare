defmodule ExLooksRare.CollectionStats.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExLooksRare.CollectionStats.Show

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

  test ".get/1 returns the collection stats" do
    use_cassette "collection_stats/show/get_ok" do
      assert {:ok, collection_stat} = ExLooksRare.CollectionStats.Show.get(@contract_address)
      assert %ExLooksRare.CollectionStat{} = collection_stat
      assert collection_stat.volume1y != nil
      assert collection_stat.count_owners != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_looks_rare: [adapter: ErrorAdapter]] do
      assert ExLooksRare.CollectionStats.Show.get(@contract_address) == {:error, :from_adapter}
    end
  end
end
