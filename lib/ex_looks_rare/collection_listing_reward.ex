defmodule ExLooksRare.CollectionListingReward do
  @type t :: %__MODULE__{}

  defstruct ~w[
    volume24h_global
    floor_global
    points
    collection
  ]a
end
