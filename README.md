# RWA Tokenization Demo

Educational smart-contract prototype illustrating:
- Asset metadata references (URI only; no documents stored on-chain).
- Admin-controlled issuance.
- Approved-address transfer gating.
- Unit supply cap.

## Run
```bash
forge build
forge test
```

## Important limitations
This contract does not create legal title, custody, investor eligibility, securities compliance, transfer-agent functionality, redemption rights, or enforceable claims against an issuer. A real RWA product requires jurisdiction-specific legal design, regulated partners, audits, identity/compliance controls, and documented asset rights. Do not deploy for real assets.
