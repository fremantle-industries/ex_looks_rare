# ExLooksRare
[![hex.pm version](https://img.shields.io/hexpm/v/ex_looks_rare.svg?style=flat)](https://hex.pm/packages/ex_looks_rare)

LooksRare API client for Elixir

## Installation

Add the `ex_looks_rare` package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_looks_rare, "~> 0.0.1"}
  ]
end
```

## Requirements

- Erlang 22+
- Elixir 1.13+

## API Documentation

https://looksrare.github.io/api-docs/

## REST API

#### Accounts

- [ ] `GET /api/v1/accounts`
- [ ] `GET /api/v1/orders`
- [ ] `POST /api/v1/orders`
- [ ] `GET /api/v1/orders/nonce`

#### Collections

- [x] `GET /api/v1/collections`
- [ ] `GET /api/v1/collections/stats`
- [ ] `GET /api/v1/collections/listing-rewards`

#### Tokens

- [ ] `GET /api/v1/tokens`

#### Events

- [ ] `GET /api/v1/events`

#### Rewards

- [ ] `GET /api/v1/rewards/all`

## Authors

- Alex Kwiatkowski - alex+git@fremantle.io

## License

`ex_looks_rare` is released under the [MIT license](./LICENSE)
