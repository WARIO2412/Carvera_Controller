#!/bin/bash
set -e  # Exit on error

# Function to print status messages
print_status() {
    echo "==> $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a Python package is installed
python_package_exists() {
    python3 -c "import $1" 2>/dev/null
    return $?
}

# Check if running on Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ]; then
        echo "Error: This script is designed to run on Ubuntu"
        exit 1
    fi
else
    echo "Error: Could not determine OS type"
    exit 1
fi

# Install system dependencies
print_status "Updating package lists"
sudo apt update

print_status "Installing system dependencies"
sudo apt install -y \
    git \
    zip \
    unzip \
    openjdk-17-jdk \
    python3-pip \
    autoconf \
    libtool \
    pkg-config \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libtinfo5 \
    cmake \
    libffi-dev \
    libssl-dev

# Install Python dependencies
print_status "Checking Python dependencies"

# Check and install buildozer
if ! command_exists buildozer; then
    print_status "Installing buildozer"
    pip3 install --upgrade buildozer
else
    print_status "buildozer is already installed"
fi

# Check and install Cython
if ! python_package_exists Cython; then
    print_status "Installing Cython"
    pip3 install --upgrade Cython==0.29.33
else
    print_status "Cython is already installed"
fi

# Check and install virtualenv
if ! python_package_exists virtualenv; then
    print_status "Installing virtualenv"
    pip3 install --upgrade virtualenv
else
    print_status "virtualenv is already installed"
fi

# Add local bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_status "Adding ~/.local/bin to PATH"
    echo 'export PATH=$PATH:~/.local/bin/' >> ~/.bashrc
    export PATH=$PATH:~/.local/bin/
fi

# Verify buildozer installation
if ! command_exists buildozer; then
    echo "Error: buildozer installation failed"
    exit 1
fi

print_status "Buildozer and dependencies installed successfully"
print_status "You may need to restart your terminal or run 'source ~/.bashrc' to update your PATH" 