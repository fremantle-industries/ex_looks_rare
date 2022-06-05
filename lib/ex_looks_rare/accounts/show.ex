defmodule ExLooksRare.Accounts.Show do
  alias ExLooksRare.Http
  alias ExLooksRare.JsonSuccessResponse

  @type address :: String.t()
  @type account :: ExLooksRare.Account.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, account | nil} | {:error, error_reason}

  @spec get(address) :: result
  def get(address) do
    "/api/v1/accounts"
    |> Http.Request.for_path()
    |> Http.Request.with_query(%{address: address})
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, %JsonSuccessResponse{success: true, data: data}}) do
    case data do
      nil -> {:ok, nil}
      _ -> Mapail.map_to_struct(data, ExLooksRare.Account, transformations: [:snake_case])
    end
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
