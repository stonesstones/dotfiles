#!/bin/bash

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# .config ディレクトリが存在しない場合は作成
mkdir -p "$HOME/.config"

# config ディレクトリ内のフォルダを ~/.config にリンク
echo "Setting up config links..."
for dir in "$SCRIPT_DIR/config/"*; do
    if [ -d "$dir" ]; then
        target="$HOME/.config/$(basename "$dir")"
        echo "Linking $dir to $target"
        ln -sfn "$dir" "$target"
    fi
done

echo "Done!"
