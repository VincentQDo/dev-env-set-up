FROM ubuntu:25.04

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
    neovim \
    && apt-get clean

# Install oh-my-zsh for easier zsh configuration
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure tmux
RUN echo "set-option -g default-shell /usr/bin/zsh" >> /root/.tmux.conf && \
    echo "set-option -sg escape-time 10" >> /root/.tmux.conf && \
    echo "set-option -g focus-events on" >> /root/.tmux.conf && \
    echo "set-option -sa terminal-features ',xterm:RGB'" >> /root/.tmux.conf

# Install Neovim KickStart
ARG CACHEBUST=1
RUN git clone https://github.com/VincentQDo/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

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

# Start neovim and let lazy vim and mason install all plugins
RUN nvim --headless +qall && \
    nvim --headless +"MasonInstall delve gopls js-debug-adapter lua-language-server prettier pyright stylua typescript-language-server sqlls sqlfluff sql-formatter pylint black ast-grep remark-language-server css-lsp tailwindcss-language-server stylelint" +qall

# Set the working directory
WORKDIR /workspace

# Expose any necessary ports (optional)
EXPOSE 8080

# Use tail to keep the container alive
ENTRYPOINT ["tail", "-f", "/dev/null"]
