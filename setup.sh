#!/bin/bash

set -e

RD=$(pwd)
CD="$HOME/.gemini"
SF="$CD/settings.json"

G='\033[0;32m'
B='\033[0;34m'
Y='\033[1;33m'
NC='\033[0m'

info() { echo -e "${B}[INFO]${NC} $1"; }
ok()   { echo -e "${G}[OK]${NC} $1"; }
warn() { echo -e "${Y}[WARN]${NC} $1"; }

for cmd in curl git; do
    command -v "$cmd" > /dev/null || { echo -e "${Y}[ERR]${NC} $cmd is not installed." >&2; exit 1; }
done

export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

info "Setting up Node..."
nvm install --lts --silent
nvm use --lts --silent

SHELL_RC="$HOME/.bashrc"
[[ "$SHELL" == *zsh* ]] && SHELL_RC="$HOME/.zshrc"

if [[ -z "${GITHUB_PERSONAL_ACCESS_TOKEN}" ]] && ! grep -q "^export GITHUB_PERSONAL_ACCESS_TOKEN=" "$SHELL_RC"; then
    warn "GITHUB_PERSONAL_ACCESS_TOKEN not set."
    echo -n "Enter GitHub PAT: "
    read -rs T
    echo ""
    echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\"$T\"" >> "$SHELL_RC"
    export GITHUB_PERSONAL_ACCESS_TOKEN="$T"
    ok "PAT saved"
else
    info "PAT already configured."
fi

info "Installing packages..."
npm install -g @google/gemini-cli \
               @modelcontextprotocol/server-github \
               @upstash/context7-mcp \
               @playwright/mcp --silent

info "Installing Playwright..."
npx playwright install --with-deps || warn "Playwright install failed"

info "Deploying configs..."
mkdir -p "$CD"

cp config/system_prompt.md "$CD/system_prompt.md"
cp config/settings.json "$SF"

sed -i.bak "s|HOME_DIR_PLACEHOLDER|$HOME|g" "$SF"
sed -i.bak "s|YOUR_GITHUB_TOKEN_HERE|${GITHUB_PERSONAL_ACCESS_TOKEN}|g" "$SF"
rm -f "$SF.bak"

ok "Done!"

echo ""
read -p "Delete repo ($RD)? [y/N]: " DEL

if [[ "$DEL" =~ ^[Yy]$ ]] && [[ "$RD" != "/" && -n "$RD" ]]; then
    cd "$HOME"
    rm -rf "$RD"
    ok "Repo deleted."
fi
