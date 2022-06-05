defmodule ExLooksRare.Events.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExLooksRare.Events.Index
  #
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

  test ".get/1 returns the listing rewards of the top 25 collections that are eligible" do
    use_cassette "events/index/get_ok" do
      assert {:ok, events} = ExLooksRare.Events.Index.get()
      assert length(events) > 0
      assert %ExLooksRare.Event{} = event = Enum.at(events, 0)
      assert event.created_at != nil
    end
  end

  test ".get/1 can filter by collection" do
    use_cassette "events/index/get_filter_collection_ok", match_requests_on: [:query] do
      assert {:ok, events} = ExLooksRare.Events.Index.get(%{collection: @contract_address})
      assert length(events) > 0
      assert Enum.all?(events, & &1.collection["address"] == @contract_address) == true
    end
  end

  test ".get/1 can filter by token id" do
    use_cassette "events/index/get_filter_token_id_ok", match_requests_on: [:query] do
      assert {:ok, events} = ExLooksRare.Events.Index.get(%{token_id: 1})
      assert length(events) > 0
      assert Enum.all?(events, & &1.token["tokenId"] == "1") == true
    end
  end

  test ".get/1 can filter by from address" do
    from_address = "0xe6B4cd8D3F0DE86836f74c9e6eA24325219F2347"

    use_cassette "events/index/get_filter_from_ok", match_requests_on: [:query] do
      assert {:ok, events} = ExLooksRare.Events.Index.get(%{from: from_address})
      assert length(events) > 0
      assert Enum.all?(events, & &1.from == from_address) == true
    end
  end

  test ".get/1 can filter by to address" do
    to_address = "0xe6B4cd8D3F0DE86836f74c9e6eA24325219F2347"

    use_cassette "events/index/get_filter_to_ok", match_requests_on: [:query] do
      assert {:ok, events} = ExLooksRare.Events.Index.get(%{to: to_address})
      assert length(events) > 0
      assert Enum.all?(events, & &1.to == to_address) == true
    end
  end

  test ".get/1 can filter by type" do
    transfer_type = "TRANSFER"

    use_cassette "events/index/get_filter_type_ok", match_requests_on: [:query] do
      assert {:ok, events} = ExLooksRare.Events.Index.get(%{type: transfer_type})
      assert length(events) > 0
      assert Enum.all?(events, & &1.type == transfer_type) == true
    end
  end

  test ".get/1 can filter by pagination" do
    use_cassette "events/index/get_filter_pagination_ok", match_requests_on: [:query] do
      assert {:ok, events_0} = ExLooksRare.Events.Index.get(%{pagination: %{first: 2}})
      assert length(events_0) == 2
      assert %ExLooksRare.Event{} = events_0_item_0 = Enum.at(events_0, 0)
      assert %ExLooksRare.Event{} = events_0_item_1 = Enum.at(events_0, 1)

      assert {:ok, events_1} = ExLooksRare.Events.Index.get(%{pagination: %{cursor: "#{events_0_item_0.id}", first: 2}})
      assert length(events_1) == 2
      assert %ExLooksRare.Event{} = events_1_item_0 = Enum.at(events_1, 0)

      assert events_0_item_1.id == events_1_item_0.id
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_looks_rare: [adapter: ErrorAdapter]] do
      assert ExLooksRare.Events.Index.get() == {:error, :from_adapter}
    end
  end
end
