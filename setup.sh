#!/bin/bash

set -e

REPO_DIR=$(pwd)

echo "=== Gemini MCP Automation Suite Setup Starting ==="

for cmd in curl git; do
    if ! command -v $cmd &> /dev/null; then
        exit 1
    fi
done

if [ -z "$NVM_DIR" ]; then
    export NVM_DIR="$HOME/.nvm"
fi

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    \. "$NVM_DIR/nvm.sh"
fi

nvm install 22
nvm use 22
nvm alias default 22

echo -n "Enter your GitHub Personal Access Token (input is hidden): "
read -s GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    exit 1
fi

echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.bashrc
echo "export TERM=xterm-256color" >> ~/.bashrc
echo "export COLORTERM=truecolor" >> ~/.bashrc

export GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN"
export TERM=xterm-256color
export COLORTERM=truecolor

npm install -g @google/gemini-cli
npm install -g @modelcontextprotocol/server-github

GEMINI_CONFIG_DIR="$HOME/.gemini"
mkdir -p "$GEMINI_CONFIG_DIR"

cp config/system_prompt.md "$GEMINI_CONFIG_DIR/system_prompt.md"

SETTINGS_FILE="$GEMINI_CONFIG_DIR/settings.json"
cp config/settings.json "$SETTINGS_FILE"

sed -i "s|HOME_DIR_PLACEHOLDER|$HOME|g" "$SETTINGS_FILE"
sed -i "s|YOUR_GITHUB_TOKEN_HERE|$GITHUB_TOKEN|g" "$SETTINGS_FILE"

echo "Setup complete! Please run 'source ~/.bashrc' and then 'gemini-cli'."

echo -n "Do you want to delete this repository directory ($REPO_DIR)? [y/N]: "
read DELETE_REPO

if [[ "$DELETE_REPO" =~ ^[Yy]$ ]]; then
    cd ~
    rm -rf "$REPO_DIR"
    echo "Repository directory deleted."
fi
