FROM ubuntu:24.10

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

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

# Configure tmux to use zsh
RUN echo "set-option -g default-shell /usr/bin/zsh" > /root/.tmux.conf

# Install Neovim KickStart
RUN git clone https://github.com/VincentQDo/kickstart.nvim "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# Start neovim and let lazy vim install all plugins
RUN nvim --headless +qall

# Set the working directory
WORKDIR /workspace

# Expose any necessary ports (optional)
EXPOSE 8080

# Use tail to keep the container alive
ENTRYPOINT ["tail", "-f", "/dev/null"]
