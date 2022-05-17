defmodule ExLooksRare.JsonErrorResponse do
  @type t :: %__MODULE__{
    success: boolean,
    name: String.t(),
    message: String.t(),
    data: nil,
    errors: [map]
  }

  defstruct ~w[
    success
    name
    message
    data
    errors
  ]a
end
