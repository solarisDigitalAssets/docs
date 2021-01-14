# solaris Digital Assets Platform Trading API Guide

## Trading Pairs

Any Trading Pair has a unique identifier, a human readable code, corresponding identifiers of the assets and timestamps.

The code is a string which consists of 2 assets separated by a slash symbol, where the first asset is a base asset and second is a quote asset. The Trading Pair always indicates a direction of the trade, for example:

- "BTC/EUR" means "I trade BTC for EUR" == "I sell BTC"
- "EUR/BTC" means "I trade EUR for BTC" == "I buy BTC"
- "BTC/ETH" means "I trade BTC for ETH"

It is possible to list all Trading Pairs on the platform or a specific Trading Pair by a unique identifier.

The possible trading directions are:

1. digital assets -> fiat assets
2. fiat assets -> digital assets
3. digital assets -> digital assets

The Trading Pair identifiers are the only way to refer a specific trading pair on our platform. Any other forms of reference, like a code, are not considered immutable and/or unique.

See:

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
      id: "00000000000000000000000000000001trpr",
      from_asset_id: "00000000000000000000000000000001asst",
      to_asset_id: "f0000000000000000000000000000001asst",
      code: "BTC/EUR",
      precision: 2,
      min_amount: "0.0001",
      created_at: "2020-07-16T11:26:41Z",
      updated_at: "2020-07-16T11:26:41Z"
    },
    {
      id: "00000000000000000000000000000002trpr",
      from_asset_id: "f0000000000000000000000000000001asst",
      to_asset_id: "00000000000000000000000000000001asst",
      code: "EUR/BTC",
      precision: 8,
      min_amount: "10",
      created_at: "2020-07-16T11:26:41Z",
      updated_at: "2020-07-16T11:26:41Z"
    }...
  ]
}
```

```
GET /v1/trading/pairs/00000000000000000000000000000001trpr/
```

```
200 OK

{
  id: "00000000000000000000000000000001trpr",
  from_asset_id: "00000000000000000000000000000001asst",
  to_asset_id: "f0000000000000000000000000000001asst",
  code: "BTC/EUR",
  precision: 2,
  min_amount: "0.0001",
  created_at: "2020-07-16T11:26:41Z",
  updated_at: "2020-07-16T11:26:41Z"
}
```

## Price

The Price endpoint provides an indicative trade price for a given Trading Pair.

The "amount" attribute is optional and the default value is 1.

The example below represents a request to estimate an approximate value of 1.123 BTC in EUR. The response contains a corresponding "value" in EUR. Both "price" and "value" attributes use a quote currency precision.

The provided result can only be used as an estimation and does not guarantee the price during the actual trade on the platform.

See:

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
  trading_pair_id: "00000000000000000000000000000001trpr",
  price: "7970.68",
  amount: "1.12300000",
  value: "8951.07",
  created_at: "2020-07-16T11:26:41Z",
  updated_at: "2020-07-16T11:26:41Z"
}
```

## Trades

Making a POST request to `v1/trading/trades` endpoint results in registering a new `Trade` on the platform.

The request body must contain the following parameters:

- `reference` - a unique identifier of the Trade, chosen by the API client
- `trading_pair_id` - represents the direction of the Trade
- `amount` - must be available on `from_account` account and be greater than `min_amount` specified by the trading pair
- `entity_id` - Solaris Digital Assets entity
- `from_account_id` - Solarisbank or Solaris Digital Assets account
- `to_account_id` - Solarisbank or Solaris Digital Assets account

Note: Solarisbank account must meet the following requirements:

1. `bic` is `SOBKDEB2XXX` (Solarisbank Corona)
2. `type` is `CHECKING_PERSONAL`
3. `locking_status` is `NO_BLOCK`
4. `status` is `ACTIVE`

In case of successful execution the endpoint responds with `201 Created` status and an initial state of the Trade which is `CREATED`.

Example below shows a creation of the `EUR/BTC` Trade(buying BTC) with the amount of 50.15 EUR, where `from_account_id` belongs to Solarisbank and `to_account_id` belongs to Solaris Digital Assets.

See:

```
POST /v1/trading/trades
GET /v1/trading/trades
GET /v1/trading/trades/{trade_id}
```

### Example

```
POST /v1/trading/trades
{
  "amount": "50.15",
  "entity_id": "e943ee28ef2774e6479073ad401df390enty",
  "trading_pair_id": "00000000000000000000000000000002trpr",
  "from_account_id": "bf20ca9ab2723fef688c510e694f7ac3cacc",
  "to_account_id": "a3727e756783a45b7350aa197bbf26cfacct",
  "reference": "abc"
}
```

```
201 Created

{
  "id": "edd1838468d2b4afc207a26b92785b50trad",
  "amount": "50.15",
  "state": "CREATED",
  "reference": "abc",
  "entity_id": "e943ee28ef2774e6479073ad401df390enty",
  "trading_pair_id": "00000000000000000000000000000002trpr",
  "from_account_id": "bf20ca9ab2723fef688c510e694f7ac3cacc",
  "to_account_id": "a3727e756783a45b7350aa197bbf26cfacct",
  "created_at": "2020-09-10T14:31:32Z",
  "updated_at": "2020-09-10T14:31:32Z"
}
```

### Cancelling a Trade

A Trade can be cancelled by the Partner given it is still on the `CREATED` state. In case the Trade cannot be found the endpoint replies with `404 Not Found` status code.

See:

```
POST /v1/trading/trades/{trade_id}/cancel
```

### Example

```
POST /v1/trading/trades/{trade_id}/cancel
```

```
200 Created

{
  "id": "edd1838468d2b4afc207a26b92785b50trad",
  "amount": "50.15",
  "state": "CANCELLED",
  "reference": "abc",
  "entity_id": "e943ee28ef2774e6479073ad401df390enty",
  "trading_pair_id": "00000000000000000000000000000002trpr",
  "from_account_id": "bf20ca9ab2723fef688c510e694f7ac3cacc",
  "to_account_id": "a3727e756783a45b7350aa197bbf26cfacct",
  "created_at": "2020-09-10T14:31:32Z",
  "updated_at": "2020-09-10T14:31:32Z"
}
```

## Approval Requests

In order to start the execution of a Trade, it must be approved by the corresponding Account holder (an Entity owning the Account).

The Trade Approval process consists of two steps:

- Creating a new ApprovalRequest for a Trade
- Approving the ApprovalRequest for a Trade

### Create an Approval Request

A POST request to `v1/trading/trades/{trade_id}/approval_request ` endpoint creates a new `Approval Request` for a `Trade` on the platform.

The request body must contain the following parameters:

- `entity_id` - Solaris Digital Assets entity
- `account_id` - Solarisbank or Solaris Digital Assets account
- `type` - The [MFA mechanism](https://github.com/solarisDigitalAssets/docs/blob/master/docs/API_Guide.md#approval-methods) that the Account holder (Entity) can use to approve their Trades.

In case of successful execution the endpoint responds with `201 Created` status and an initial state of the `Approval Request` which is `PENDING`.

See:

```
POST /v1/trading/trades/{trade_id}/approval_request
```

### Example

```
POST /v1/trading/trades/{trade_id}/approval_request
{
  "entity_id": "e943ee28ef2774e6479073ad401df390enty",
  "account_id": "bf20ca9ab2723fef688c510e694f7ac3cacc",
  "type": "AUTHY_PUSH"
}
```

```
201 Created

{
  "id": "bd4c882738787267cdf849fcb799b45eaprq",
  "trade_id": "00000000000000000000000000000001trad",
  "type": "AUTHY_PUSH",
  "state": "PENDING",
  "created_at": "2020-10-02T15:10:12Z",
  "updated_at": "2020-10-02T15:10:12Z"
}
```

### Fetch the current state of an Approval Request

A GET request to `v1/trading/trades/{trade_id}/approval_request` endpoint returns the current state of an `Approval Request` of a given `Trade` on the platform.

In case of successful execution the endpoint responds with `200 OK` status and the current state from the `Approval Request`.

### Example

```
GET /v1/trading/trades/{trade_id}/approval_request
```

```
200 OK

{
  "id": "bd4c882738787267cdf849fcb799b45eaprq",
  "trade_id": "00000000000000000000000000000001trad",
  "type": "AUTHY_PUSH",
  "state": "APPROVED",
  "created_at": "2020-10-02T15:10:12Z",
  "updated_at": "2020-10-02T15:10:12Z"
}
```

### Approves an Approval Request

A POST request to `v1/trading/trades/{trade_id}/approval_request/approve` endpoint approves the current `Approval Request` of a given `Trade` on the platform.

In case of successful execution the endpoint responds with `200 OK` status and the current state from the `Approval Request`.

### Example

```
POST /v1/trading/trades/{:trade_id}/approval_request/approve
{
  "response": "012345" # The challenge that the customer received via SMS
}
```

```
200 OK

{
  "id": "bd4c882738787267cdf849fcb799b45eaprq",
  "trade_id": "00000000000000000000000000000001trad",
  "type": "SMS",
  "state": "APPROVED",
  "created_at": "2020-10-02T15:10:12Z",
  "updated_at": "2020-10-02T15:10:12Z"
}
```
