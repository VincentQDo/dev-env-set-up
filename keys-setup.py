import os
import subprocess

# Prompt the user for their email address
email = input("Enter your email address for SSH key generation: ")

# Define the directory and key filenames
key_dir = os.path.expanduser("~/docker_ssh_keys")
ed25519_key = os.path.join(key_dir, "id_ed25519")
rsa_key = os.path.join(key_dir, "id_rsa")

# Check if the directory exists, if not, create it
if not os.path.exists(key_dir):
    print(f"Directory {key_dir} does not exist. Creating it now.")
    os.makedirs(key_dir)
else:
    print(f"Directory {key_dir} already exists.")

# Generate Ed25519 SSH key
if not os.path.isfile(ed25519_key):
    subprocess.run(["ssh-keygen", "-t", "ed25519", "-C", email, "-f", ed25519_key, "-N", ""])
    print(f"Ed25519 key generated at {ed25519_key}")
else:
    print(f"Ed25519 key already exists at {ed25519_key}")

# Generate RSA SSH key
if not os.path.isfile(rsa_key):
    subprocess.run(["ssh-keygen", "-t", "rsa", "-b", "4096", "-C", email, "-f", rsa_key, "-N", ""])
    print(f"RSA key generated at {rsa_key}")
else:
    print(f"RSA key already exists at {rsa_key}")

