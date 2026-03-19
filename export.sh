#!/bin/bash
# Export Cloudflare KV NIP-05 registry to nostr.json and commit to Git.
# Runs daily via cron. Provides a public backup so registered users
# can self-host if the service ever goes offline.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CF_ACCOUNT_ID="de0b68adb7519d1f20d940e5d4a90ba4"
CF_KV_NAMESPACE_ID="76e45b3a728a4669b3285d658d5ef0a6"
CF_API_TOKEN="zt00MLkv1h0XevRZtfORXh_0n_2GGLxmPY0gWdY8"
BASE="https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/storage/kv/namespaces/${CF_KV_NAMESPACE_ID}"

cd "$REPO_DIR"

# Fetch all keys
KEYS=$(curl -sf "${BASE}/keys" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  | python3 -c "import sys,json; print(' '.join(k['name'] for k in json.load(sys.stdin)['result']))")

# Build nostr.json
NAMES="{}"
for KEY in $KEYS; do
  VALUE=$(curl -sf "${BASE}/values/${KEY}" -H "Authorization: Bearer ${CF_API_TOKEN}")
  NAMES=$(echo "$NAMES" | python3 -c "
import sys,json
d = json.load(sys.stdin)
d['$KEY'] = '$VALUE'
print(json.dumps(d))
")
done

# Write nostr.json
python3 -c "
import json
names = json.loads('$NAMES')
output = {'names': names}
print(json.dumps(output, indent=2))
" > nostr.json

echo "Exported $(echo $KEYS | wc -w) names to nostr.json"

# Commit and push if changed
if ! git diff --quiet nostr.json 2>/dev/null; then
  git add nostr.json
  git commit -m "registry: $(date -u +%Y-%m-%dT%H:%M:%SZ) — $(echo $KEYS | wc -w) names"
  git push origin main
  echo "Pushed update"
else
  echo "No changes"
fi
