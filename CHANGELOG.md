# Changelog

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
