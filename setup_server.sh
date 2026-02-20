#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Server setup (Zsh + Oh My Zsh + Powerlevel10k)"
echo ""

# 1. ログインシェルで Zsh を起動するようにする
PROFILE=""
[ -f "$HOME/.bash_profile" ] && PROFILE="$HOME/.bash_profile"
[ -z "$PROFILE" ] && [ -f "$HOME/.profile" ] && PROFILE="$HOME/.profile"
[ -z "$PROFILE" ] && PROFILE="$HOME/.bash_profile"

ZSH_EXEC_LINE='if [ -x /bin/zsh ]; then exec /bin/zsh; fi'
if [ -n "$PROFILE" ]; then
  if ! grep -q 'exec /bin/zsh' "$PROFILE" 2>/dev/null; then
    echo "==> Adding zsh to $PROFILE"
    echo "" >> "$PROFILE"
    echo "# Use zsh as login shell (dotfiles)" >> "$PROFILE"
    echo "$ZSH_EXEC_LINE" >> "$PROFILE"
  else
    echo "==> zsh already configured in $PROFILE, skipping"
  fi
fi

# 2. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed, skipping"
fi

# 3. Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
  echo "==> Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.zshrc"
else
  if ! grep -q 'powerlevel10k' "$HOME/.zshrc" 2>/dev/null; then
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> "$HOME/.zshrc"
  fi
  echo "==> Powerlevel10k already installed, skipping"
fi

# 4. .p10k.zsh をホームにコピー
if [ -f "$SCRIPT_DIR/.p10k.zsh" ]; then
  cp "$SCRIPT_DIR/.p10k.zsh" "$HOME/"
  echo "==> Copied .p10k.zsh to $HOME/"
else
  echo "==> Warning: .p10k.zsh not found in repo, skipping"
fi

echo ""
echo "==> Server setup done. Log out and log back in (or run 'exec zsh') to use Zsh + Powerlevel10k."
