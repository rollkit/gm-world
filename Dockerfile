FROM docker.io/alpine:latest

# Install system dependencies
RUN apk update && apk add --no-cache bash curl jq git make sed ranger vim

# Set the working directory
WORKDIR /app

# Make sure GOPATH is set
ENV GOPATH /usr/local/go
ENV PATH $GOPATH/bin:$PATH

# Install Rollkit dependencies
RUN curl -sSL https://rollkit.dev/install.sh | sh -s v0.13.4

# Install GM rollup
RUN bash -c "$(curl -sSL https://rollkit.dev/install-gm-rollup.sh)"

# Update the working directory
WORKDIR /app/gm

# Initialize the Rollkit configuration
RUN rollkit toml init

# Edit rollkit.toml config_dir
RUN sed -i 's/config_dir = "gm"/config_dir = "\.\/\.gm"/g' rollkit.toml

# Launch GM rollup
CMD rollkit start --rollkit.aggregator --rollkit.da_address http://localhost:7980

# CMD ["bash"]
# CMD ["tail -F /dev/null"]
