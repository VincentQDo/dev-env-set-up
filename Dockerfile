FROM ubuntu:24.10

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8

# Update the package list and install necessary development tools
RUN apt-get update && \
    apt-get install -y \
    neovim \
    tmux \
    zsh \
    git \
    build-essential \
    curl \
    wget \
    python3 \
    python3-pip \
    golang \
    rustc \
    cargo \
    nodejs \
    npm \
    openjdk-17-jdk \
    kafkacat \
    unzip \
    ripgrep \
    luarocks \
    && apt-get clean

# Copy the Nerd Font archive to the container
COPY 0xProto.tar.xz /tmp/0xProto.tar.xz

# Extract the Nerd Font and install it
RUN mkdir -p ~/.local/share/fonts && \
    tar -xJf /tmp/0xProto.tar.xz -C ~/.local/share/fonts && \
    fc-cache -fv && \
    rm /tmp/0xProto.tar.xz

# Install oh-my-zsh for easier zsh configuration
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure tmux
RUN echo "set-option -g default-shell /usr/bin/zsh" >> /root/.tmux.conf && \
    echo "set-option -sg escape-time 10" >> /root/.tmux.conf && \
    echo "set-option -g focus-events on" >> /root/.tmux.conf && \
    echo "set-option -sa terminal-features ',xterm:RGB'" >> /root/.tmux.conf

# Install Neovim KickStart
RUN git clone https://github.com/VincentQDo/kickstart.nvim "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Start neovim and let lazy vim install all plugins
RUN nvim --headless +qall
RUN nvim --headless +"MasonInstall prettier pyright typescript-language-server lua-language-server stylua" +qall
# Set the working directory
WORKDIR /workspace

# Expose any necessary ports (optional)
EXPOSE 8080

# Use tail to keep the container alive
ENTRYPOINT ["tail", "-f", "/dev/null"]
