defmodule ExLooksRare.CollectionListingRewards.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExLooksRare.CollectionListingRewards.Index

  defmodule ErrorAdapter do
    def send(_request) do
      {:error, :from_adapter}
    end
  end

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1 returns the listing rewards of the top 25 collections that are eligible" do
    use_cassette "collection_listing_rewards/index/get_ok" do
      assert {:ok, listing_rewards} = ExLooksRare.CollectionListingRewards.Index.get()
      assert length(listing_rewards) == 25
      assert %ExLooksRare.CollectionListingReward{} = listing_reward = Enum.at(listing_rewards, 0)
      assert listing_reward.volume24h_global != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_looks_rare: [adapter: ErrorAdapter]] do
      assert ExLooksRare.CollectionListingRewards.Index.get() == {:error, :from_adapter}
    end
  end
end
