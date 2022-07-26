# Changelog

## 26-07-2022

API updated to v0.27.0

- Introduced new error responses, which correspond to HTTP statuses 422, 429, 503.

## 11-05-2022

- Added filtering documentation to `Custody_API_Guide.md`

## 08-09-2021

- Update `Trading Limits#remaing_amount` description on `Brokerage_API_Guide.md`

## 07-09-2021

- Update `openapi.yml` `ApprovalRequests` to reflect latest state
- Update `Custody_API_Guide.md` to correct examples for ApprovalRequests

## 31-08-2021

- Update `openapi.yml` `info.contact.email` attribute to `sda-tech@solarisbank.de`
- Fix typos on `openapi.yml` and `Brokerage_API_Guide.md`
- Remove `business_id` duplicates from `openapi.yml`
- Remove `DRAFT` mentions from `Brokerage_API_Guide.md`
- Update `Brokerage_API_Guide.md` to the latest version

## 01-06-2021

API updated to v0.26.0

- Update ClosureRequests flows
- Add recommendations about withdrawing full balance of the Account

## 23-04-2021

- Document reason `ORDINARY_INTERNAL` on ClosureRequests
- Add documentation on `PROCESSING` state for ClosureRequests
- Add documentation on `legal_closure_scheduled_at` field for ClosureRequests

## 24-03-2021

- Document Entities of type `REPRESENTATIVE_PERSON`
- Document ApprovalMethod of type `GROUP`
- Document ApprovalRequest of type `GROUP`

## 21-01-2021

- Document Entity states
- Document Entity states transitions on account closure flow
- Update `openapi.yml`

## 19-01-2021

- Mark and rename references to Brokerage API as `DRAFT`

## 15-01-2021

- Removes mentions of CRYPTO -> CRYPTO Trades from `Brokerage_API_Guide.md` documentation
- Renames `API_Guide.md` to `Custody_API_Guide.md`
- Fixes links to documentations on `README.md`

## 14-01-2021

API updated to v0.25.0

- Added documentation for `Brokerage` related endpoints
- Added `Brokerage_API_Guide.md` documentation

## 08-01-2021

API updated to v0.24.0

- Added documentation for ClosureRequests
- Added documentation for Entity states

## 02-12-2020

API updated to v0.23.1

- Removed some syntactically incorrect commas from the openapi.yml

## 01-12-2020

API updated to v0.23.0

- Introduced endpoint for accepting terms and conditions
- Introduced Asset of type `FIAT`
- Added some fixes for end-to-end reference
- Added some fixes for `BUSINESS` Entity

## 09-11-2020

API updated to v0.22.0

- Introduced `BUSINESS` Entity type

## 05-11-2020

API updated to v0.21.2

- Introduced End to End ID
- Introduced Terms and Conditions Endpoint

## 04-11-2020

API updated to v0.21.0

- Updated Open API specification with Production sDA API url

## 20-10-2020

API updated to v0.20.1

- Added Pagination support for endpoints that list resources.
- Added Sorting support for endpoints that list resources.
- Added Filtering support for endpoints that list resources.

## 12-10-2020

API updated to v0.20.0

- Updated Transaction representation: `fee_account_id` is a common attribute now
- Updated Account representation: `isolation` attribute is now considered deprecated, isolation level is now determined by Account's Asset
- Updated Asset representation: an additional `token_url` attribute determines underlying token protocol (e.g. ERC20) and the smart contract address
- Withdrawal Processing Transactions are no longer documented: as the network fees for processing Withdrawals are now paid by the platform, Withdrawal Processing Transactions no longer appear in Partner's Accounts

## 02-10-2020

API updated to v0.19.1

Fixes to Open API specification:

- documented `isolation` attribute in Account creation
- more minor fixes

## 02-10-2020

API updated to v0.19.0

This update introduces some breaking changes:

- Individual Wallets are removed: Wallets as a resource are no longer available or required to operate Accounts
- Accounts no longer have `wallet_id`, instead they have `asset_id` as a direct reference of the Asset they are holding
- Transactions no longer have `total_amount` attribute, although `total_amount` is still accepted as a parameter to a Withdrawal or Transfer request

Other changes in this update:

- Introduced a way to specify from which Account the fees are going to be collected for Withdrawals: `fee_account_id`
- Introduced a new Transaction type: WITHDRAWAL_FEE

## 28-09-2020

API updated to v0.18.0

- Introduced support for canceling Transactions

## 17-08-2020

API updated to v0.17.0:

- Introduced support for ERC-20 tokens
- Introduced endpoint for creating Wallets
- Added `type` attribute to Wallets
- Added `type` attribute to Accounts

## 04-08-2020

API updated to v0.16.0

- Remove balance atttribute from Wallet resource representation

## 26-06-2020

API updated to v0.15.0:

- Introduced Approval Method of type: SMS.
- Introduced Approval Requests for the new Approval Method of type SMS.

## 19-05-2020

API updated to v0.14.0:

- Added attribute `fee_paying_account_id` for Wallets
- Added attribute `address_validation`, `tx_min_amount` for Assets
- Added Transactions Validation Checks

## 04-05-2020

API updated to v0.13.0:

- Introduced Callbacks for the Transactions
- Added Table of Contents

## 07-04-2020

API updated to v0.12.0:

- Added a section about the recommended Entity onboarding flow

## 28-11-2019

API updated to v0.11.0:

- Introduced APPROVED state in Transactions
- Introduced Approval Methods; implemented methods are: AUTHY_PUSH, DSA_ED25519
- Introduced Approval Requests for Approval Methods
- Breaking Change: Removed Transaction Approval endpoints

## 27-09-2019

API updated to v0.9.0:

- Introduced Transfers between Accounts
- Introduced Transfer approval process, implemented approval methods are: MFA, DSA_ED25519
- Introduced Transfer Outgoing Transaction type
- Introduced Transfer Incoming Transaction type

## 20-09-2019

API updated to v0.8.0:

- Updated Withdrawal processing flow
- Introduced Transaction approval process, implemented approval methods are: MFA, DSA_ED25519
- Introduced Withdrawal Processing Transaction type
- Updated examples/api-client to support DSA_ED25519 approval method
- Introduced Account Available Balance

## 26-07-2019

API updated to v0.6.0:

- Specification format upgraded to OpenAPI 3.0, `swagger.yml` is replaced with `openapi.yml`
- Specification is updated to be more strict and descriptive
- Updated specification structure, added examples, so it's more friendly to automatic API documentation generators like SwaggerUI etc
- Minor changes in phrasing and formatting in texts in API specification and API Guide
