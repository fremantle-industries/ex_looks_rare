defmodule ExLooksRare.CollectionStat do
  @type t :: %__MODULE__{}

  defstruct ~w[
    address
    count_owners
    total_supply
    floor_price
    floor_change24h
    floor_change7d
    floor_change30d
    market_cap
    volume24h
    average24h
    count24h
    change24h
    volume7d
    average7d
    count7d
    change7d
    volume1m
    average1m
    count1m
    change1m
    volume3m
    average3m
    count3m
    change3m
    volume6m
    average6m
    count6m
    change6m
    volume1y
    average1y
    count1y
    change1y
    volume_all
    average_all
    count_all
  ]a
end
