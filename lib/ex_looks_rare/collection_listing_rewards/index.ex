defmodule ExLooksRare.CollectionListingRewards.Index do
  alias ExLooksRare.Http
  alias ExLooksRare.JsonSuccessResponse

  @type params :: %{
    optional(:offset) => non_neg_integer,
    optional(:limit) => non_neg_integer
  }
  @type collection :: ExLooksRare.CollectionListingReward.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [collection]} | {:error, error_reason}

  @spec get() :: result
  @spec get(params) :: result
  def get(params \\ %{}) do
    "/api/v1/collections/listing-rewards"
    |> Http.Request.for_path()
    |> Http.Request.with_query(params)
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
