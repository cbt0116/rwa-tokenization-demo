# RWA Tokenization Demo

A small educational Solidity prototype for representing fractional units of a referenced real-world asset (RWA) in an on-chain registry.

The project demonstrates basic asset registration, admin-controlled issuance, an approved-address allowlist, and a per-asset unit supply cap. It is a learning prototype—not a tokenization platform or a production-ready investment system.

## What it implements

The core contract is `RwaRegistry` in `src/RwaRegistry.sol`.

- **Asset registration:** the admin creates an asset record with a reference code, metadata URI, and maximum unit supply.
- **Investor approval:** the admin can approve or revoke addresses through `setApproved`.
- **Unit issuance:** only the admin can issue units to approved addresses.
- **Supply cap:** issuance is limited so the total issued units for an asset cannot exceed its registered `totalUnits`.
- **Allowlisted transfers:** units can move only when both the sender and recipient are approved.
- **Events:** registration, approval changes, issuance, and transfers emit events for off-chain monitoring.

The contract uses a simple internal balance mapping. These units are **not ERC-20 tokens** and are not automatically compatible with wallets, exchanges, or token infrastructure.

## Contract overview

| Contract element | Purpose |
| --- | --- |
| `registerAsset(code, uri, totalUnits)` | Register an asset and its unit cap |
| `setApproved(investor, status)` | Add or remove an approved address |
| `issue(id, investor, amount)` | Issue units within the asset's supply cap |
| `transferUnits(id, to, amount)` | Transfer units between approved addresses |
| `assets(id)` / `units(id, account)` | Read asset details and account balances |
| `totalIssued(id)` | Read the total units issued for an asset |

The deployer becomes the initial admin and is initially approved.

## Requirements

- [Foundry](https://getfoundry.sh/)
- Solidity 0.8.24 (configured in `foundry.toml`)

## Build

Clone the repository and run:

```bash
forge build
```

## Tests

Run:

```bash
forge test
```

There is currently no committed test directory or Foundry test contract in this repository. Do not interpret a successful `forge test` invocation with zero tests as evidence that the contract has been meaningfully tested.

Recommended tests include:
- only-admin access for registration, approval, and issuance
- approval and revocation behavior
- rejection of zero amounts and invalid asset registration
- enforcement of the per-asset supply cap
- transfer rejection for unapproved senders or recipients
- balance and total-issued accounting across transfers
- fuzz and invariant tests for supply and balance accounting

## Important limitations and security considerations

This is a deliberately limited educational example.

- **No legal rights are created:** an on-chain record does not establish ownership, title, custody, redemption rights, or an enforceable claim against an issuer.
- **No compliance system:** the allowlist is only an admin-controlled address flag. It does not perform identity checks, KYC/AML, sanctions screening, investor eligibility checks, or jurisdiction controls.
- **No asset verification:** the contract stores a reference code and URI string; it does not verify the underlying asset, documents, valuation, custody, or metadata content.
- **Centralized administration:** one admin controls approvals, registration, and issuance. There is no multisig, role separation, admin rotation, or emergency process.
- **Limited lifecycle controls:** the current implementation has an `active` field but no function to deactivate an asset.
- **No standard token interface:** units are internal accounting entries, not ERC-20/ERC-721/ERC-1155 tokens.
- **No audit or production test suite:** the project has not been presented as independently audited or production-ready.

Do not deploy this contract for real assets, accept investments, or rely on it for legal or financial rights.

A real RWA system requires jurisdiction-specific legal structuring, enforceable asset rights, regulated and operational partners, robust identity/compliance controls, security reviews, and documented redemption and dispute processes.

## Possible next steps

1. Add Foundry unit tests, fuzz tests, and invariants.
2. Add explicit asset lifecycle controls and carefully designed admin governance.
3. Evaluate a standard token interface if interoperability is a project requirement.
4. Add robust metadata and asset-document verification processes off-chain.
5. Document the legal, custody, compliance, and redemption model before considering any real-world use.

## License

No license file is currently included. Unless a license is added, the repository should not be assumed to grant permission to reuse, modify, or distribute the code.
