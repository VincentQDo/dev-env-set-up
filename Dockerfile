FROM debian:bookworm-20240701

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary development tools
RUN apt-get update && \
    apt-get install -y \
    && apt-get clean

# Set the working directory
WORKDIR /workspace

# Copy the current directory contents into the container at /workspace
COPY . /workspace

# Expose any necessary ports (optional)
EXPOSE 8080

# Default command to run when container starts
CMD ["/bin/bash"]
