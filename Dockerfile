FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"
RUN flutter doctor
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy the project files
COPY . .

# Get dependencies
RUN flutter pub get

# Start the app
CMD ["flutter", "run", "--web-port", "3000", "--web-hostname", "0.0.0.0"]