defmodule ExLooksRare.Http.Client do
  alias ExLooksRare.Http

  @type request :: Http.Request.t()
  @type success_response :: ExLooksRare.JsonSuccessResponse.t()
  @type error_reason :: ExLooksRare.JsonErrorResponse.t() | Jason.DecodeError.t() | Http.Adapter.error_reason()
  @type result :: {:ok, success_response} | {:error, error_reason}

  @spec domain :: String.t()
  def domain, do: Application.get_env(:ex_looks_rare, :domain, "api.looksrare.org")

  @spec protocol :: String.t()
  def protocol, do: Application.get_env(:ex_looks_rare, :protocol, "https")

  @spec adapter :: module
  def adapter, do: Application.get_env(:ex_looks_rare, :adapter, Http.HTTPoisonAdapter)

  @spec get(request) :: result
  def get(request) do
    request
    |> Http.Request.with_method(:get)
    |> send()
  end

  @spec send(request) :: result
  def send(request) do
    http_adapter = adapter()

    request
    |> Http.Request.with_protocol(protocol())
    |> Http.Request.with_domain(domain())
    |> http_adapter.send()
    |> parse_response()
  end

  defp parse_response({:ok, %Http.Response{status_code: status_code, body: body}}) do
    cond do
      status_code >= 200 && status_code < 300 ->
        case Jason.decode(body) do
          {:ok, json} -> Mapail.map_to_struct(json, ExLooksRare.JsonSuccessResponse, transformations: [:snake_case])
          {:error, _} = error -> error
        end

      status_code >= 400 && status_code < 500 ->
        case Jason.decode(body) do
          {:ok, json} ->
            case Mapail.map_to_struct(json, ExLooksRare.JsonErrorResponse, transformations: [:snake_case]) do
              {:ok, response} -> {:error, response}
            end

          {:error, _} = result ->
            result
        end

      true ->
        {:error, body}
    end
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
