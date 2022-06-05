defmodule ExLooksRare.Tokens.Show do
  alias ExLooksRare.Http
  alias ExLooksRare.JsonSuccessResponse

  @type address :: String.t()
  @type token_id :: non_neg_integer
  @type collection :: ExLooksRare.Token.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, collection} | {:error, error_reason}

  @spec get(address, token_id) :: result
  def get(collection_address, token_id) do
    "/api/v1/tokens"
    |> Http.Request.for_path()
    |> Http.Request.with_query(%{collection: collection_address, tokenId: token_id})
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, %JsonSuccessResponse{success: true, data: data}}) do
    Mapail.map_to_struct(data, ExLooksRare.Token, transformations: [:snake_case])
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
