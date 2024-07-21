#!/bin/bash

# Prompt user for GitHub username and email
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter your GitHub email: " GITHUB_EMAIL

# Set your GitHub credentials
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$GITHUB_EMAIL"

# Switch the remote URL of your Neovim Kickstart repo to SSH
cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
git remote set-url origin git@github.com:VincentQDo/kickstart.nvim.git

# Verify the remote URL change
echo "Updated remote URL for Neovim Kickstart repository:"
git remote -v

echo "GitHub SSH setup completed."

