#!/bin/bash

set -e

REPO_DIR=$(pwd)

echo "=== Gemini MCP Automation Suite Setup Starting ==="

for cmd in curl git; do
    command -v "$cmd" > /dev/null || exit 1
done

export NVM_DIR="$HOME/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

npm install -g @google/gemini-cli

echo -n "Enter your GitHub Personal Access Token (input is hidden): "
read -s GITHUB_TOKEN
echo ""

[ -z "$GITHUB_TOKEN" ] && exit 1

BASHRC="$HOME/.bashrc"
touch "$BASHRC"

grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" "$BASHRC" 2>/dev/null || echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\"$GITHUB_TOKEN\"" >> "$BASHRC"
grep -q "TERM=xterm-256color" "$BASHRC" 2>/dev/null || echo 'export TERM=xterm-256color' >> "$BASHRC"
grep -q "COLORTERM=truecolor" "$BASHRC" 2>/dev/null || echo 'export COLORTERM=truecolor' >> "$BASHRC"

export GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN"
export TERM=xterm-256color
export COLORTERM=truecolor

GEMINI_CONFIG_DIR="$HOME/.gemini"
mkdir -p "$GEMINI_CONFIG_DIR"

cp config/system_prompt.md "$GEMINI_CONFIG_DIR/system_prompt.md"

SETTINGS_FILE="$GEMINI_CONFIG_DIR/settings.json"
cp config/settings.json "$SETTINGS_FILE"

sed -i.bak "s|HOME_DIR_PLACEHOLDER|$HOME|g" "$SETTINGS_FILE"
sed -i.bak "s|YOUR_GITHUB_TOKEN_HERE|$GITHUB_TOKEN|g" "$SETTINGS_FILE"
rm -f "$SETTINGS_FILE.bak"

echo "Setup complete! Run: source ~/.bashrc && gemini-cli"

echo -n "Delete this repository directory ($REPO_DIR)? [y/N]: "
read DELETE_REPO

if [[ "$DELETE_REPO" =~ ^[Yy]$ ]] && [[ "$REPO_DIR" != "/" && -n "$REPO_DIR" ]]; then
    cd ~
    rm -rf "$REPO_DIR"
    echo "Repository directory deleted."
fi
