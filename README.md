# Gemini MCP Automation Suite

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

[JA](README.md) | [EN](README.en.md)

Ubuntu 24.04環境において Gemini CLI と GitHub MCP サーバーを迅速かつ安全に自動構築するためのツールスイートです．
煩雑な環境構築手順を一つのスクリプトで完結させ，開発効率を最大化します．

## 主な機能

- **自動環境構築**：Node.js 22 (via nvm) の導入からパッケージインストールまでを自動化します．
- **安全な認証管理**：対話形式で GitHub トークンを取得し，`.bashrc` へ安全にセットします．
- **設定同期**：MCP サーバー用 `settings.json` およびカスタムシステムプロンプトを自動配置します．
- **ポータビリティ**：リポジトリをクローンして実行するだけで，即座に同一の AI 開発環境を再現可能です．

## インストール

リポジトリのルートで以下のコマンドを実行してください．

```bash
bash setup.sh
```

このスクリプトは，Node.js のセットアップ，必要なライブラリのインストール，設定ファイルの配置などを自動的に行います．

※設定を反映させるため，実行後に以下のコマンドで `~/.bashrc` を再読み込みしてください．

```bash
source ~/.bashrc
```

## 使用方法

### Gemini CLI の起動
```bash
gemini
```

## 必要条件

- OS: Linux (Ubuntu 24.04 推奨)
- curl, git

## ライセンス

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
