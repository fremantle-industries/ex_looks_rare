defmodule ExLooksRare.Collection do
  @type t :: %__MODULE__{}

  defstruct ~w[
    address
    owner
    name
    description
    symbol
    type
    website_link
    facebook_link
    twitter_link
    instagram_link
    telegram_link
    medium_link
    discord_link
    is_verified
    is_explicit
  ]a
end
