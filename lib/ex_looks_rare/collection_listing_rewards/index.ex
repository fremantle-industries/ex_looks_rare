defmodule ExLooksRare.CollectionListingRewards.Index do
  alias ExLooksRare.Http
  alias ExLooksRare.JsonSuccessResponse

  @type listing_reward :: ExLooksRare.CollectionListingReward.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [listing_reward]} | {:error, error_reason}

  @spec get() :: result
  def get do
    "/api/v1/collections/listing-rewards"
    |> Http.Request.for_path()
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, %JsonSuccessResponse{success: true, data: data}}) do
    data
    |> Enum.map(&Mapail.map_to_struct(&1, ExLooksRare.CollectionListingReward, transformations: [:snake_case]))
    |> Enum.reduce(
      {:ok, []},
      fn
        {:ok, i}, {:ok, acc} -> {:ok, acc ++ [i]}
        _, _acc -> {:error, :parse_result_item}
      end
    )
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
