FROM debian:bookworm-20240701

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
    && apt-get clean

# Install oh-my-zsh for easier zsh configuration
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set the working directory
WORKDIR /workspace

# Copy the current directory contents into the container at /workspace
COPY . /workspace

# Expose any necessary ports (optional)
EXPOSE 8080

# Set zsh as the default shell
CMD ["/bin/zsh"]

