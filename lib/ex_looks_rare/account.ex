defmodule ExLooksRare.Account do
  @type t :: %__MODULE__{}

  defstruct ~w[
    address
    name
    biography
    website_link
    instagram_link
    twitter_link
    is_verified
  ]a
end
