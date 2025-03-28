# dev-env-set-up
How to use:

1. Clone this to host machine.
2. Run command `python keys-setup.py` (This should create ssh keys at a custom location)
3. Run docker compose (this will run container with a bund of dev ports bound to the host)
4. Once container started, go into container and run the `github-setup.sh` script (this should set up GitHub username and password for git and set nvim kickstart to point to its ssh link instead of https)
