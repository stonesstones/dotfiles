# dotfiles

開発環境用の設定ファイル群です。Neovim（LazyVim）、WezTerm、Zsh（Powerlevel10k）などを含みます。

---

## クイックスタート

```bash
# 1. リポジトリをクローン
git clone --recursive <this-repo-url> ~/dotfiles
cd ~/dotfiles

# 2. 設定を ~/.config にリンク
./link.sh
```

---

## セットアップ手順

### 1. 設定のリンク

`link.sh` を実行すると、`config/` 内のディレクトリが `~/.config/` にシンボリックリンクされます。

```bash
./link.sh
```

- **nvim** … LazyVim（サブモジュール）
- **wezterm** … WezTerm の設定

### 2. Neovim の更新

Neovim 設定は [LazyVim starter](https://github.com/hamakou108/lazyvim-starter) をサブモジュールで参照しています。

```bash
git submodule update --remote config/nvim
```

### 3. サーバー環境（新規マシン）向け

新規サーバーやクリーンな環境で Zsh + Powerlevel10k を使う場合の手順です。**以下を一括で実行するには `./setup_server.sh` を実行してください。**

手動で行う場合の手順：

1. **ログインシェルを Zsh に変更**

   `${HOME}/.bashrc` の末尾に追加：

   ```bash
   if [ -x /bin/zsh ]; then
       exec /bin/zsh
   fi
   ```

2. **Oh My Zsh をインストール**

   [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) のインストーラを実行します。既存の `${HOME}/.zshrc` は `${HOME}/.zshrc.pre-oh-my-zsh` に退避されます。

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Powerlevel10k をインストール**
   [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
   ```

4. **Powerlevel10k の設定をコピー**

   このリポジトリのテーマ設定をホームにコピーします。

   ```bash
   cp .p10k.zsh "${HOME}/"
   ```

5. server.zshrcを${HOME}/.zshrcにシンボリックリンクをはる
もともとあった.zshrcは.zshrc_backupとする
---

## 構成

| パス | 説明 |
|------|------|
| `config/nvim` | Neovim（LazyVim）設定（git submodule） |
| `config/wezterm` | WezTerm 設定 |
| `.p10k.zsh` | Powerlevel10k テーマ設定 |
| `link.sh` | `config/*` を `~/.config/` にリンクするスクリプト |
| `setup_server.sh` | サーバー向け Zsh + Oh My Zsh + Powerlevel10k を一括セットアップするスクリプト |
