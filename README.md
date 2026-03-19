# NIP-05 Registry — jorgenclaw.ai

Public backup of all NIP-05 names registered at `jorgenclaw.ai`.

## Why this exists

If jorgenclaw.ai ever goes offline, registered users should not lose their NIP-05 identity. This repo contains a daily export of every `name → pubkey` mapping. You can self-host this file at your own domain to keep your NIP-05 working.

## File

- `nostr.json` — the full registry in NIP-05 format

## Self-hosting

If the service goes down, serve `nostr.json` at `https://yourdomain.ai/.well-known/nostr.json` and update your NIP-05 identifier in your Nostr profile to `yourname@yourdomain.ai`.

## Register

DM Jorgenclaw on Nostr with `register yourname` to get `yourname@jorgenclaw.ai` for 5,000 sats.

npub: `npub16pg5zadrrhseg2qjt9lwfcl50zcc8alnt7mnaend3j04wjz4gnjqn6efzc`
