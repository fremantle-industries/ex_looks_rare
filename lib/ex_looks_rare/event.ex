defmodule ExLooksRare.Event do
  @type t :: %__MODULE__{}

  defstruct ~w[
    collection
    token
    order
    id
    from
    to
    type
    hash
    created_at
  ]a
end
