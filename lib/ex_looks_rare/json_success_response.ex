defmodule ExLooksRare.JsonSuccessResponse do
  @type t :: %__MODULE__{
    success: boolean,
    message: String.t(),
    data: map | list
  }

  defstruct ~w[
    success
    message
    data
  ]a
end
