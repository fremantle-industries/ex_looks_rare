defmodule ExLooksRare.Accounts.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExLooksRare.Accounts.Show

  @beeple_account_address "0xc6b0562605D35eE710138402B878ffe6F2E23807"

  defmodule ErrorAdapter do
    def send(_request) do
      {:error, :from_adapter}
    end
  end

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1 returns the matching account" do
    use_cassette "accounts/show/get_logged_in_ok" do
      assert {:ok, account} = ExLooksRare.Accounts.Show.get("0xe6B4cd8D3F0DE86836f74c9e6eA24325219F2347")
      assert %ExLooksRare.Account{} = account
      assert account.name != nil
      assert account.is_verified != nil
    end
  end

  test ".get/1 returns a nil account when it hasn't logged into LooksRare" do
    use_cassette "accounts/show/get_not_logged_in_ok" do
      assert {:ok, account} = ExLooksRare.Accounts.Show.get(@beeple_account_address)
      assert account == nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_looks_rare: [adapter: ErrorAdapter]] do
      assert ExLooksRare.Accounts.Show.get(@beeple_account_address) == {:error, :from_adapter}
    end
  end
end
