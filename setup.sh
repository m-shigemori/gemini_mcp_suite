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
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${Y}[ERR]${NC} $cmd is not installed." >&2
        exit 1
    fi
done

export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

\. "$NVM_DIR/nvm.sh"

info "Setting up Node 22..."
nvm install 22 --silent
nvm use 22 --silent

if [[ -z "${GITHUB_PERSONAL_ACCESS_TOKEN}" ]] && ! grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" ~/.bashrc; then
    warn "GITHUB_PERSONAL_ACCESS_TOKEN not set."
    echo -n "Enter GitHub PAT: "
    read -rs T
    echo ""
    echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\"$T\"" >> ~/.bashrc
    export GITHUB_PERSONAL_ACCESS_TOKEN="$T"
    ok "PAT saved to .bashrc"
else
    info "PAT already configured."
fi

info "Installing packages..."
npm install -g @google/gemini-cli \
               @modelcontextprotocol/server-github \
               @upstash/context7-mcp \
               @playwright/mcp --silent

info "Installing Playwright..."
npx playwright install --with-deps > /dev/null

info "Deploying configs..."
mkdir -p "$CD"

cp config/system_prompt.md "$CD/system_prompt.md"
cp config/settings.json "$SF"
sed -i "s|HOME_DIR_PLACEHOLDER|$HOME|g" "$SF"
sed -i "s|YOUR_GITHUB_TOKEN_HERE|${GITHUB_PERSONAL_ACCESS_TOKEN}|g" "$SF"

ok "Done!"

echo ""
read -p "Delete repo ($RD)? [y/N]: " DEL

if [[ "$DEL" =~ ^[Yy]$ ]]; then
    cd "$HOME"
    rm -rf "$RD"
    ok "Repo deleted."
fi
