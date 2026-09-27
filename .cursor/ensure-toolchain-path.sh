#!/usr/bin/env bash
# Keep the .NET SDK, nbgv, and terraform installed by .slipway/cloud-setup.sh
# on PATH for later shells. That script exports PATH only for its own process.
set -euo pipefail

marker='# adlc-demo toolchain'
rc="${HOME}/.bashrc"
touch "$rc"
if grep -q "$marker" "$rc"; then
  exit 0
fi

cat >> "$rc" <<'EOF'

# adlc-demo toolchain
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$HOME/.local/bin:$PATH"
EOF
