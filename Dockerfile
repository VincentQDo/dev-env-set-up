FROM ubuntu:noble

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8

# Update the package list and install necessary development tools
RUN apt-get update && \
    apt-get install -y \
    tmux \
    zsh \
    git \
    build-essential \
    curl \
    wget \
    golang \
    nodejs \
    npm \
    unzip \
    ripgrep \
    luarocks \
    htop \
    tree \
    python3 \
    python3-venv \
    && apt-get clean

# Install oh-my-zsh for easier zsh configuration
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure tmux
RUN echo "set-option -g default-shell /usr/bin/zsh" >> /root/.tmux.conf && \
    echo "set-option -sg escape-time 10" >> /root/.tmux.conf && \
    echo "set-option -g focus-events on" >> /root/.tmux.conf && \
    echo "set-option -sa terminal-features ',xterm:RGB'" >> /root/.tmux.conf

# Install Lazygit
RUN git clone https://github.com/VincentQDo/lazygit.git && \
    cd lazygit && \
    go install && \
    mv /root/go/bin/lazygit /usr/local/bin/ && \
    cd .. && \
    rm -rf lazygit

# Ensure locale is generated and set correctly
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Installing Neovim Stable from source
RUN curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz -o nvim-linux64.tar.gz
RUN ls && tar -xzf nvim-linux64.tar.gz -C /usr/local && \
    ln -s /usr/local/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux64.tar.gz && \
    ls -l /usr/local/bin/nvim && ls -l /usr/local/nvim-linux-x86_64/bin/nvim && \
    nvim --version

ENV EDITOR=nvim
# Install Neovim KickStart and set up plugins
ARG CACHEBUST=1
RUN git clone -b feat/personal-settings https://github.com/VincentQDo/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
RUN nvim --headless +qall
RUN nvim --headless +"MasonInstall gopls sqlls sqlfluff json-lsp lua-language-server pyright bash-language-server dockerfile-language-server" +qall
RUN nvim --headless +"MasonInstall svelte-language-server tailwindcss-language-server yaml-language-server html-lsp typescript-language-server css-lsp" +qall
RUN nvim --headless +"MasonInstall black prettier stylua eslint-lsp" +qall
RUN nvim --headless +"MasonInstall delve js-debug-adapter debugpy" +qall
# Set the working directory
WORKDIR /workspace

# Expose any necessary ports (optional)
EXPOSE 8080

# Use tail to keep the container alive
ENTRYPOINT ["tail", "-f", "/dev/null"]
