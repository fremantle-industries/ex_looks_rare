defmodule ExLooksRare.Token do
  @type t :: %__MODULE__{}

  defstruct ~w[
    id
    collection_address
    token_id
    token_uri
    image_uri
    is_explicit
    is_animated
    flag
    collection
    attributes
  ]a
end
