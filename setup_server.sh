#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Server setup (Zsh + Oh My Zsh + Powerlevel10k)"
echo ""

# 1. ログインシェルを Zsh に変更 → ~/.bashrc の末尾に追加
ZSH_EXEC_LINE='if [ -x /bin/zsh ]; then
    exec /bin/zsh
fi'
if ! grep -q 'exec /bin/zsh' "$HOME/.bashrc" 2>/dev/null; then
  echo "==> Adding zsh to ~/.bashrc"
  echo "" >> "$HOME/.bashrc"
  echo "# Use zsh as login shell (dotfiles)" >> "$HOME/.bashrc"
  echo "$ZSH_EXEC_LINE" >> "$HOME/.bashrc"
else
  echo "==> zsh already configured in ~/.bashrc, skipping"
fi

# 2. Oh My Zsh をインストール
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed, skipping"
fi

# 3. Powerlevel10k をインストール（Oh My Zsh の custom themes へ）
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "==> Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  echo "==> Powerlevel10k already installed, skipping"
fi

# 4. .p10k.zsh をホームにコピー
if [ -f "$SCRIPT_DIR/.p10k.zsh" ]; then
  cp "$SCRIPT_DIR/.p10k.zsh" "$HOME/"
  echo "==> Copied .p10k.zsh to $HOME/"
else
  echo "==> Warning: .p10k.zsh not found in repo, skipping"
fi

# 5. server.zshrc を ~/.zshrc にシンボリックリンク（既存 .zshrc は .zshrc_backup に退避）
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "==> Backing up existing .zshrc to .zshrc_backup"
  mv "$HOME/.zshrc" "$HOME/.zshrc_backup"
fi
echo "==> Linking server.zshrc to ~/.zshrc"
ln -sf "$SCRIPT_DIR/server.zshrc" "$HOME/.zshrc"

echo ""
echo "==> Server setup done. Log out and log back in (or run 'exec zsh') to use Zsh + Powerlevel10k."
