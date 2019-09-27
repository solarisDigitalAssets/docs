# Changelog

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
