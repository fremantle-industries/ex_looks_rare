defmodule ExLooksRare.Collections.Show do
  alias ExLooksRare.Http
  alias ExLooksRare.JsonSuccessResponse

  @type address :: String.t()
  @type collection :: ExLooksRare.Collection.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, collection} | {:error, error_reason}

  @spec get(address) :: result
  def get(address) do
    "/api/v1/collections"
    |> Http.Request.for_path()
    |> Http.Request.with_query(%{address: address})
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, %JsonSuccessResponse{success: true, data: data}}) do
    Mapail.map_to_struct(data, ExLooksRare.Collection, transformations: [:snake_case])
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
