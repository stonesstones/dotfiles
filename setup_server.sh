#!/bin/bash
set -e

# Colors (disabled when stdout is not a terminal)
if [ -t 1 ]; then
  C_RESET='\033[0m'
  C_BOLD='\033[1m'
  C_SECTION='\033[1;36m'   # Bold cyan (section headers)
  C_OK='\033[1;32m'        # Bold green (run/complete)
  C_SKIP='\033[33m'        # Yellow (skip)
  C_WARN='\033[1;33m'      # Bold yellow (warning)
  C_DONE='\033[1;35m'      # Bold magenta (final message)
else
  C_RESET= C_BOLD= C_SECTION= C_OK= C_SKIP= C_WARN= C_DONE=
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${C_SECTION}${C_BOLD}==> Server setup (Zsh + Oh My Zsh + Powerlevel10k)${C_RESET}"
echo ""

# 1. Use Zsh as login shell — append to $HOME/.bashrc
echo -e "${C_SECTION}[1/5] Set Zsh as login shell${C_RESET}"
ZSH_EXEC_LINE='if [ -x /bin/zsh ]; then
    exec /bin/zsh
fi'
if ! grep -q 'exec /bin/zsh' "$HOME/.bashrc" 2>/dev/null; then
  echo -e "${C_OK}==> Adding zsh to $HOME/.bashrc${C_RESET}"
  echo "" >> "$HOME/.bashrc"
  echo "# Use zsh as login shell (dotfiles)" >> "$HOME/.bashrc"
  echo "$ZSH_EXEC_LINE" >> "$HOME/.bashrc"
else
  echo -e "${C_SKIP}==> zsh already configured in $HOME/.bashrc, skipping${C_RESET}"
fi
echo ""

# 2. Install Oh My Zsh
echo -e "${C_SECTION}[2/5] Install Oh My Zsh${C_RESET}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${C_OK}==> Installing Oh My Zsh...${C_RESET}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo -e "${C_SKIP}==> Oh My Zsh already installed, skipping${C_RESET}"
fi
echo ""

# 3. Install Powerlevel10k (into Oh My Zsh custom themes)
echo -e "${C_SECTION}[3/5] Install Powerlevel10k${C_RESET}"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo -e "${C_OK}==> Installing Powerlevel10k...${C_RESET}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  echo -e "${C_SKIP}==> Powerlevel10k already installed, skipping${C_RESET}"
fi
echo ""

# 4. Copy .p10k.zsh to home
echo -e "${C_SECTION}[4/5] Copy .p10k.zsh to home${C_RESET}"
if [ -f "$SCRIPT_DIR/.p10k.zsh" ]; then
  cp "$SCRIPT_DIR/.p10k.zsh" "$HOME/"
  echo -e "${C_OK}==> Copied .p10k.zsh to $HOME/${C_RESET}"
else
  echo -e "${C_WARN}==> Warning: .p10k.zsh not found in repo, skipping${C_RESET}"
fi
echo ""

# 5. Symlink server.zshrc to ~/.zshrc (back up existing .zshrc to .zshrc_backup)
echo -e "${C_SECTION}[5/5] Link server.zshrc to $HOME/.zshrc${C_RESET}"
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo -e "${C_OK}==> Backing up existing .zshrc to .zshrc_backup${C_RESET}"
  mv "$HOME/.zshrc" "$HOME/.zshrc_backup"
fi
echo -e "${C_OK}==> Linking server.zshrc to $HOME/.zshrc${C_RESET}"
ln -sf "$SCRIPT_DIR/server.zshrc" "$HOME/.zshrc"

echo ""
echo -e "${C_DONE}==> Server setup done. Log out and log back in (or run 'exec zsh') to use Zsh + Powerlevel10k.${C_RESET}"
