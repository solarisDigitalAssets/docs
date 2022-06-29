# Solaris Digital Assets Platform - Brokerage API Guide


## Table of Contents

- [Brokerage API Guide](#solaris-digital-assets-platform---brokerage-api-guide)
  - [Table of Contents](#table-of-contents)
  - [Terms and Condition](#terms-and-conditions)
    - [Example](#example)
  - [Trading Pairs](#trading-pairs)
    - [Example](#example-1)
  - [Price](#price)
    - [Example](#example-2)
  - [Exchange Rates](#exchange-rates)
    - [Daily Exchange Rates](#daily-exchange-rates)
      - [Example](#example-3)
    - [Hourly Exchange Rates](#hourly-exchange-rates)
      - [Example](#example-4)
    - [Minute Exchange Rates](#minute-exchange-rates)
      - [Example](#example-5)
  - [Trades](#trades)
    - [Example](#example-6)
    - [Trade Callbacks](#trade-callbacks)
  - [Approval Requests](#approval-requests)
  - [Trading limits](#trading-limits)
    - [Example](#example-7)


## Terms and Conditions

Entities are required to accept trading terms and conditions in order to request trades on the platform. This is done by issuing a POST request to `/v1/entities/{entity_id}/trading_terms_and_conditions`.
It is the partner's responsibility to present trading terms and conditions to the customer. The partner MUST NOT call this endpoint otherwise.

Format:

```
POST /v1/entities/{entity_id}/trading_terms_and_conditions
```

### Example

```
POST /v1/entities/10ef67dc895d6c19c273b1ffba0c1692enty/trading_terms_and_conditions
```

## Trading Pairs

Any Trading Pair has a unique identifier, a human readable code, corresponding identifiers of the assets and timestamps.

It’s only possible to trade those trading pairs whose `is_tradable` attribute is set to true.

The code is a string which consists of 2 assets separated by a slash symbol, where the first asset is a base asset and second is a quote asset. The Trading Pair always indicates a direction of the trade, for example:

- "BTC/EUR" means "I trade BTC for EUR" == "I sell BTC"
- "EUR/BTC" means "I trade EUR for BTC" == "I buy BTC"

It is possible to list all Trading Pairs on the platform or a specific Trading Pair by a unique identifier.

The possible trading directions are:

1. digital assets -> fiat assets
2. fiat assets -> digital assets

The Trading Pair identifiers are the only way to refer a specific trading pair on our platform. Any other forms of reference, like a code, are not considered immutable and/or unique.

Format:

```
GET /v1/trading/pairs
GET /v1/trading/pairs/{trading_pair_id}
```

### Example

```
GET /v1/trading/pairs
```

```
200 OK

{
  "items": [
    {
      "id": "00000000000000000000000000000001trpr",
      "from_asset_id": "00000000000000000000000000000001asst",
      "to_asset_id": "f0000000000000000000000000000001asst",
      "is_tradable": true,
      "code": "BTC/EUR",
      "precision": 2,
      "min_amount": "0.0001",
      "created_at": "2020-07-16T11:26:41Z",
      "updated_at": "2020-07-16T11:26:41Z"
    },
    {
      "id": "00000000000000000000000000000002trpr",
      "from_asset_id": "f0000000000000000000000000000001asst",
      "to_asset_id": "00000000000000000000000000000001asst",
      "is_tradable": true,
      "code": "EUR/BTC",
      "precision": 8,
      "min_amount": "10",
      "created_at": "2020-07-16T11:26:41Z",
      "updated_at": "2020-07-16T11:26:41Z"
    },
    ...
  ]
}
```

```
GET /v1/trading/pairs/00000000000000000000000000000001trpr
```

```
200 OK

{
  "id": "00000000000000000000000000000001trpr",
  "from_asset_id": "00000000000000000000000000000001asst",
  "to_asset_id": "f0000000000000000000000000000001asst",
  "is_tradable": true,
  "code": "BTC/EUR",
  "precision": 2,
  "min_amount": "0.0001",
  "created_at": "2020-07-16T11:26:41Z",
  "updated_at": "2020-07-16T11:26:41Z"
}
```

## Price

The Price endpoint provides an indicative trade price for a given Trading Pair.

The `amount` attribute is optional and defaults to `min_amount` attribute of a chosen `Trading Pair`.

The example below represents a request to estimate an approximate value of 1.123 BTC in EUR. The response contains a corresponding "value" in EUR. Both "price" and "value" attributes use a quote currency precision.

The provided result can only be used as an estimation and does not guarantee the price during the actual trade on the platform.

Format:

```
GET /v1/trading/pairs/{trading_pair_id}/price
GET /v1/trading/pairs/{trading_pair_id}/price?amount={amount}
```

### Example

```
GET /v1/trading/pairs/00000000000000000000000000000001trpr/price?amount=1.123
```

```
200 OK

{
  "trading_pair_id: "00000000000000000000000000000001trpr",
  "from_amount": "1.12300000",
  "traded_from_amount": "1.12300000",
  "traded_to_amount": "9956.64",
  "to_amount": "9857.07",
  "price": "8866.11",
  "fee_amount": "99.57",
  "created_at": "2020-07-16T11:26:41Z",
  "updated_at": "2020-07-16T11:26:41Z"
}
```

## Exchange Rates

### Daily Exchange Rates

A GET request to `/v1/trading/pairs/{trading_pair_id}/daily_rates` endpoint returns historical daily exchange rates for a given `Trading Pair`.

Format:

```
GET /v1/trading/pairs/{trading_pair_id}/daily_rates
```

#### Example

```
GET /v1/trading/pairs/00000000000000000000000000000001trpr/daily_rates
```

```
200 OK

{
  "items": [
    {
      "trading_pair_id": "00000000000000000000000000000001trpr",
      "price": "7728.19",
      "starts_at": "2021-01-01T01:00:00Z",
      "ends_at": "2021-01-02T01:00:00Z"
    },
    {
      "trading_pair_id": "00000000000000000000000000000001trpr",
      "price": "7728.19",
      "starts_at": "2021-01-02T01:00:00Z",
      "ends_at": "2021-01-03T01:00:00Z"
    },
    ...
  ]
}
```

### Hourly Exchange Rates

A GET request to `/v1/trading/pairs/{trading_pair_id}/hourly_rates` endpoint returns historical hourly exchange rates for a given `Trading Pair`.

Format:

```
GET /v1/trading/pairs/{trading_pair_id}/hourly_rates
```

#### Example

```
GET /v1/trading/pairs/00000000000000000000000000000001trpr/hourly_rates
```

```
200 OK

{
  "items": [
    {
      "trading_pair_id": "00000000000000000000000000000001trpr",
      "price": "7728.19",
      "starts_at": "2021-01-01T01:00:00Z",
      "ends_at": "2021-01-01T02:00:00Z"
    },
    {
      "trading_pair_id": "00000000000000000000000000000001trpr",
      "price": "7728.19",
      "starts_at": "2021-01-01T02:00:00Z",
      "ends_at": "2021-01-01T03:00:00Z"
    },
    ...
  ]
}
```

### Minute Exchange Rates

A GET request to `/v1/trading/pairs/{trading_pair_id}/minute_rates` endpoint returns historical minute exchange rates for a given `Trading Pair`.

Format:

```
GET /v1/trading/pairs/{trading_pair_id}/minute_rates
```

#### Example

```
GET /v1/trading/pairs/00000000000000000000000000000001trpr/minute_rates
```

```
200 OK

{
  "items": [
    {
      "trading_pair_id": "00000000000000000000000000000001trpr",
      "price": "7728.19",
      "starts_at": "2021-01-01T00:01:00Z",
      "ends_at": "2021-01-01T00:02:00Z"
    },
    {
      "trading_pair_id": "00000000000000000000000000000001trpr",
      "price": "7728.19",
      "starts_at": "2021-01-01T00:02:00Z",
      "ends_at": "2021-01-01T00:03:00Z"
    },
    ...
  ]
}
```

## Trades

### Creating trade
Making a POST request to `/v1/trading/trades` endpoint results in registering a new `Trade` on the platform.

The request body must contain the following parameters:

- `reference` - a unique identifier of the Trade, chosen by the API client
- `trading_pair_id` - represents a currency pair and a direction of the Trade
- `from_amount` - must be available on `from_account` account and be greater than `min_amount` specified by the TradingPair
- `entity_id` - Solaris Digital Assets entity
- `from_account_id` - Solarisbank or Solaris Digital Assets account
- `to_account_id` - Solarisbank or Solaris Digital Assets account

Note: Solarisbank account must meet the following requirements:

1. `bic` is `SOBKDEB2XXX` (Solarisbank Corona)
2. `type` is `CHECKING_PERSONAL` or `CHECKING_BUSINESS`
3. `locking_status` is `NO_BLOCK`
4. `status` is `ACTIVE`

Note: TradingPair must meet the following requirement:

- `is_tradable` should be `true`

In case of successful execution the endpoint responds with `201 Created` status and an initial state of the Trade which is `PENDING`.

The newly created Trade has a `PENDING` state and contains the trade estimations within a corresponding field. The next step is Trade approval(see Approval Requests). Once the Trade is approved it is being executed and eventually reaches a `COMPLETED` state. When it happens the following fields, which are initially empty, will be populated:

- `fee_amount` - a fee amount, collected by the Platform. This amount is always denominated in EUR(`f0000000000000000000000000000001asst`) and collected prior to the exchange for FIAT -> CRYPTO trades and after the exchange for CRYPTO -> FIAT trades.
- `traded_from_amount` - an amount which was traded on the exchange
- `traded_to_amount` - an amount received from the exchange
- `to_amount` - an amount which `entity_id` has received
- `price` - `traded_to_amount / traded_from_amount` rounded to the precision of the TradingPair

List of the Trade states:

| State     | Meaning |
|-----------|---------|
| PENDING   | The Trade has been created and awaits an approval |
| APPROVED  | The Trade has been approved, the Platform will now collect the payment of `from_amount` from the `from_account` and perform the order execution |
| EXECUTED  | The Trade has been executed and can no longer be failed, the Platform will now proceed with the settlement of `to_amount` to the `to_account` |
| COMPLETED | The Trade has been successfully completed |
| CANCELLED | The Trade has been cancelled by the client(see Cancelling a Trade) |
| FAILING   | The Trade has been approved, but could not get executed, so the Platform is in a process of reversing the progress |
| FAILED    | The Trade has been successfully failed, the payment for the Trade, if happened, has been refunded |

Example below shows a creation of the `EUR/BTC` Trade(buying BTC for EUR) with the amount of 209.1 EUR, where `from_account_id` belongs to Solarisbank and `to_account_id` belongs to Solaris Digital Assets.

Format:

```
POST /v1/trading/trades
GET /v1/trading/trades
GET /v1/trading/trades/{trade_id}
```

#### Example

```
POST /v1/trading/trades
{
  "from_amount": "209.1",
  "entity_id": "b6ef80668690fa4dfbb51a3bc49a1fb7enty",
  "trading_pair_id": "00000000000000000000000000000002trpr",
  "from_account_id": "57e837a08685eff2cee29e82b6b09857cacc",
  "to_account_id": "d4f01daea26362d0de5fe89cb0f8d905acct",
  "reference": "9bcf5ffa4bb4d4ebbf92fb74f3a61f85"
}
```

```
201 Created

{
  "id": "82d19e27542a21c950eaae13059cf5f5trad",
  "from_amount": "209.10",
  "traded_from_amount": null,
  "traded_to_amount": null,
  "to_amount": null,
  "fee_amount": null,
  "price": null,
  "state": "PENDING",
  "reference": "9bcf5ffa4bb4d4ebbf92fb74f3a61f85",
  "entity_id": "b6ef80668690fa4dfbb51a3bc49a1fb7enty",
  "trading_pair_id": "00000000000000000000000000000002trpr",
  "from_account_id": "57e837a08685eff2cee29e82b6b09857cacc",
  "to_account_id": "d4f01daea26362d0de5fe89cb0f8d905acct",
  "failure_reason": null,
  "estimations": {
    "traded_from_amount": "207.00",
    "traded_to_amount": "0.02288435",
    "to_amount": "0.02288435",
    "fee_amount": "2.10",
    "price": "0.00011055"
  },
  "created_at": "2021-11-26T14:35:45Z",
  "updated_at": "2021-11-26T14:35:45Z"
}
```

### Cancelling a Trade

A Trade can be cancelled by the Partner given its state is `PENDING`. In case the Trade cannot be found the endpoint replies with `404 Not Found` status code.

Format:

```
POST /v1/trading/trades/{trade_id}/cancel
```

#### Example

```
POST /v1/trading/trades/{trade_id}/cancel
```

```
200 OK

{
  "id": "82d19e27542a21c950eaae13059cf5f5trad",
  "from_amount": "209.10",
  "traded_from_amount": null,
  "traded_to_amount": null,
  "to_amount": null,
  "fee_amount": null,
  "price": null,
  "state": "CANCELLED",
  "reference": "9bcf5ffa4bb4d4ebbf92fb74f3a61f85",
  "entity_id": "b6ef80668690fa4dfbb51a3bc49a1fb7enty",
  "trading_pair_id": "00000000000000000000000000000002trpr",
  "from_account_id": "57e837a08685eff2cee29e82b6b09857cacc",
  "to_account_id": "d4f01daea26362d0de5fe89cb0f8d905acct",
  "failure_reason": null,
  "estimations": {
    "traded_from_amount": "207.00",
    "traded_to_amount": "0.02288435",
    "to_amount": "0.02288435",
    "fee_amount": "2.10",
    "price": "0.00011055"
  },
  "created_at": "2021-11-26T14:35:45Z",
  "updated_at": "2021-11-26T14:35:45Z"
}
```
### Trade callbacks
All the trade state transitions that affect external parties
generate callbacks which is documented in [Callbacks section](https://github.com/solarisDigitalAssets/docs/blob/master/docs/Custody_API_Guide.md#callbacks)
of Custody documentation.

## Approval Requests

All Trades created by the API request MUST be approved by the corresponding Account holder (an Entity owning the accounts specified in the Trade), before it will be processed and executed by the Platform.

The Trade approval process consists of two steps:

- Creating a new ApprovalRequest for a Trade
- Approving the ApprovalRequest

The complete guide on how to create and approve ApprovalRequests and a list of ApprovalMethods available on the platform is available under [Custody API](https://github.com/solarisDigitalAssets/docs/blob/master/docs/Custody_API_Guide.md#approvalmethods). The `resource_type` must be `TRADE` and the `resource_id` must be an id of the Trade.

## Trading Limits

This endpoint is used to show current trading limits configuration for an Entity and the remaining amount they are allowed to trade.

The Trading Limit object includes the following attributes:

- `interval` an Integer, which represents a time interval `amount` is applied within, in seconds
- `amount` a String, which represents maximum cumulative amount of Trades within `interval`, in EUR with EUR asset precision
- `remaining_amount` a String, which represents remaining amount available within `interval`, in EUR with EUR asset precision.
  It is calculated as `amount - sum(Traded amounts in EUR)` where the sum represents a cumulative trade amount during a given time window
  that has its `start time` defined as `DATE NOW - interval` and its `end time` as `DATE NOW`.

Format:

```
GET /v1/entities/{entity_id}/trading_limits
```

#### Example

```
GET /v1/entities/{entity_id}/trading_limits
```

```
200 OK

{
  "entity_id": "e0a26b1b54a6009d9ad9c6efd3aa5c77enty",
  "interval": 604800,
  "amount": "50000.00",
  "remaining_amount": "49686.69",
  "created_at": "2021-02-11T22:40:59Z",
  "updated_at": "2021-02-11T22:40:59Z"
}
```
