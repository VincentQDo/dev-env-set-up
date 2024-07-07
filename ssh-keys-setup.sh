#!/bin/bash

# Prompt the user for their email address
read -p "Enter your email address for SSH key generation: " EMAIL

# Define the directory and key filenames
KEY_DIR=~/docker_ssh_keys
ED25519_KEY="$KEY_DIR/id_ed25519"
RSA_KEY="$KEY_DIR/id_rsa"

# Check if the directory exists, if not, create it
if [ ! -d "$KEY_DIR" ]; then
  echo "Directory $KEY_DIR does not exist. Creating it now."
  mkdir -p "$KEY_DIR"
else
  echo "Directory $KEY_DIR already exists."
fi

# Generate Ed25519 SSH key
if [ ! -f "$ED25519_KEY" ]; then
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$ED25519_KEY" -N ""
  echo "Ed25519 key generated at $ED25519_KEY"
else
  echo "Ed25519 key already exists at $ED25519_KEY"
fi

# Generate RSA SSH key
if [ ! -f "$RSA_KEY" ]; then
  ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$RSA_KEY" -N ""
  echo "RSA key generated at $RSA_KEY"
else
  echo "RSA key already exists at $RSA_KEY"
fi

