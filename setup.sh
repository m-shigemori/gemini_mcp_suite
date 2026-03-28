#!/bin/bash

set -e

REPO_DIR=$(pwd)

echo "======================================="
echo "   Gemini MCP Automation Suite Setup   "
echo "======================================="

echo "[1/6] Checking dependencies..."
for cmd in curl git; do
    if ! command -v "$cmd" > /dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

echo "[2/6] Setting up Node.js (nvm)..."
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
\. "$NVM_DIR/nvm.sh"

nvm install --lts > /dev/null
nvm use --lts > /dev/null
nvm alias default 'lts/*' > /dev/null

echo "[3/6] Installing Gemini CLI..."
npm install -g @google/gemini-cli > /dev/null

echo "[4/6] Configuring credentials..."
echo -n "Enter your GitHub Personal Access Token (input is hidden): "
read -s GITHUB_TOKEN
echo ""
[ -z "$GITHUB_TOKEN" ] && exit 1

BASHRC="$HOME/.bashrc"
if ! grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" "$BASHRC"; then
    cat << EOF >> "$BASHRC"
export GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN"
export TERM=xterm-256color
export COLORTERM=truecolor
EOF
fi

export GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN"
export TERM=xterm-256color
export COLORTERM=truecolor

echo "[5/6] Deploying configuration files..."
GEMINI_CONFIG_DIR="$HOME/.gemini"
mkdir -p "$GEMINI_CONFIG_DIR"

if [ -f "config/system_prompt.md" ]; then
    cp config/system_prompt.md "$GEMINI_CONFIG_DIR/"
fi

SETTINGS_FILE="$GEMINI_CONFIG_DIR/settings.json"
if [ -f "config/settings.json" ]; then
    cp config/settings.json "$SETTINGS_FILE"
    sed -i "s|HOME_DIR_PLACEHOLDER|$HOME|g" "$SETTINGS_FILE"
    sed -i "s|YOUR_GITHUB_TOKEN_HERE|$GITHUB_TOKEN|g" "$SETTINGS_FILE"
fi

echo "[6/6] Finalizing..."
echo "Setup complete! Run: source ~/.bashrc && gemini"

echo -n "Delete this repository directory ($REPO_DIR)? [y/N]: "
read DELETE_REPO

if [[ "$DELETE_REPO" =~ ^[Yy]$ ]] && [[ "$REPO_DIR" != "/" ]]; then
    cd ~
    rm -rf "$REPO_DIR"
    echo "Directory deleted."
fi