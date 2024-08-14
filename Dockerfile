FROM rust:1.71.1-slim AS builder
WORKDIR /usr/src/app
COPY Cargo.toml Cargo.lock ./
COPY ./src ./src
RUN cargo build
COPY Conf.toml ./
RUN cargo build --release

# Second stage: Create a minimal runtime environment
FROM ubuntu:22.04

# Install any required dependencies (optional, remove if not needed)
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy the compiled binary and configuration file from the builder stage
COPY --from=builder /usr/src/app/target/release/rust_verusd_rpc_server ./
COPY --from=builder /usr/src/app/Conf.toml ./

# Set the command to run the binary
CMD ["./rust_verusd_rpc_server"]
