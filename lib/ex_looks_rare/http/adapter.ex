defmodule ExLooksRare.Http.Adapter do
  alias ExLooksRare.Http

  @type error_reason :: :timeout | :nxdomain | Maptu.Extension.non_strict_error_reason() | term
  @type result :: {:ok, Http.Response.t()} | {:error, error_reason}

  @callback send(Http.Request.t()) :: result
end
