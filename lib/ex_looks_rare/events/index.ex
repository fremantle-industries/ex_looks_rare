defmodule ExLooksRare.Events.Index do
  alias ExLooksRare.Http
  alias ExLooksRare.JsonSuccessResponse

  @type address :: String.t()
  @type pagination :: %{
    optional(:first) => non_neg_integer,
    optional(:cursor) => non_neg_integer
  }
  @type params :: %{
    optional(:collection) => address,
    optional(:token_id) => non_neg_integer,
    optional(:from) => address,
    optional(:to) => address,
    optional(:type) => String.t(),
    optional(:pagination) => pagination
  }
  @type event :: ExLooksRare.Event.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [event]} | {:error, error_reason}

  @spec get() :: result
  @spec get(params) :: result
  def get(params \\ %{}) do
    transformed_params = transform_params(params)

    "/api/v1/events"
    |> Http.Request.for_path()
    |> Http.Request.with_query(transformed_params)
    |> Http.Client.get()
    |> parse_response()
  end

  defp transform_params(params) do
    params
    |> transform_token_id()
    |> transform_pagination()
  end

  defp transform_token_id(params) do
    case params[:token_id] do
      nil -> params
      token_id -> params |> Map.delete(:token_id) |> Map.put(:tokenId, token_id)
    end
  end

  defp transform_pagination(params) do
    case params[:pagination] do
      nil ->
        params

      pagination ->
        p = Jason.encode!(pagination)
        Map.put(params, :pagination, p)
    end
  end

  defp parse_response({:ok, %JsonSuccessResponse{success: true, data: data}}) do
    data
    |> Enum.map(&Mapail.map_to_struct(&1, ExLooksRare.Event, transformations: [:snake_case]))
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
