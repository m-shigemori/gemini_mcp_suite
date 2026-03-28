# Gemini MCP Automation Suite

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

[JA](README.md) | [EN](README.en.md)

This is a tool suite for quickly and safely automating the setup of Gemini CLI and MCP (Model Context Protocol) servers on Ubuntu 24.04.
Streamline complex environment setup steps into a single script to maximize development efficiency.

## Key Features

- **Automated Environment Setup**: Automates everything from Node.js (via nvm) installation to package installation.
- **Secure Authentication Management**: Interactively retrieves GitHub tokens and securely sets them in `.bashrc`.
- **Config Sync**: Automatically deploys `settings.json` for MCP servers and custom system prompts.
- **Portability**: Clone the repository and run the script to instantly reproduce the same AI development environment.

## Requirements

- OS: Linux (Ubuntu 24.04 recommended)
- curl, git

## Installation

Run the following command at the root of the repository:

```bash
bash setup.sh
```

This script automatically handles Node.js setup, library installation, and configuration file placement.

※ To apply the settings, reload `~/.bashrc` with the following command after execution:

```bash
source ~/.bashrc
```

## Usage

### Launch Gemini CLI
```bash
gemini
```

## Supported MCPs

- GitHub
- Context7
- Playwright

## License

[MIT License](LICENSE)

[contributors-shield]: https://img.shields.io/github/contributors/m-shigemori/gemini_mcp_suite?style=for-the-badge
[contributors-url]: https://github.com/m-shigemori/gemini_mcp_suite/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/m-shigemori/gemini_mcp_suite?style=for-the-badge
[forks-url]: https://github.com/m-shigemori/gemini_mcp_suite/network/members
[stars-shield]: https://img.shields.io/github/stars/m-shigemori/gemini_mcp_suite?style=for-the-badge
[stars-url]: https://github.com/m-shigemori/gemini_mcp_suite/stargazers
[issues-shield]: https://img.shields.io/github/issues/m-shigemori/gemini_mcp_suite?style=for-the-badge
[issues-url]: https://github.com/m-shigemori/gemini_mcp_suite/issues
[license-shield]: https://img.shields.io/github/license/m-shigemori/gemini_mcp_suite?style=for-the-badge
[license-url]: https://github.com/m-shigemori/gemini_mcp_suite/blob/main/LICENSE
