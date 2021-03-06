defmodule ExLooksRare.Http.RequestTest do
  use ExUnit.Case, async: false
  alias ExLooksRare.Http.Request
  doctest ExLooksRare.Http.Request

  test ".for_path/1 returns a request struct with the given path" do
    request = Request.for_path("/v2/collections")
    assert request.path == "/v2/collections"
  end

  test ".with_query/2 encodes query parameters with www_form encoding" do
    request = %Request{} |> Request.with_query(%{hello: "dear world"})
    assert request.query == "hello=dear+world"
  end

  test ".with_domain/2 assigns the domain to the returned request struct" do
    request = %Request{} |> Request.with_domain("google.com")
    assert request.domain == "google.com"
  end

  test ".with_protocol/2 assigns the protocol to the returned request struct" do
    request = %Request{} |> Request.with_protocol("ftp")
    assert request.protocol == "ftp"
  end
end
