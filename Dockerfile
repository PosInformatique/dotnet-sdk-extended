ARG DOTNET_SDK_VERSION=9.0

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION}

LABEL org.opencontainers.image.title="P.O.S Informatique - .NET SDK Extended"
LABEL org.opencontainers.image.description="Extended .NET SDK Docker image with sqlcmd and Node.JS"
LABEL org.opencontainers.image.version="${DOTNET_SDK_VERSION}"
LABEL org.opencontainers.image.url="https://github.com/PosInformatique/dotnet-sdk-extended"
LABEL org.opencontainers.image.source="https://github.com/PosInformatique/dotnet-sdk-extended"
LABEL org.opencontainers.image.authors="Gilles TOURREAU <gilles.tourreau@pos-informatique.com>"
LABEL org.opencontainers.image.vendor="P.O.S Informatique"
LABEL org.opencontainers.image.licenses="MIT"

# Install sqlcmd
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list; \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y sqlcmd nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the following path in the PATH:
# - /opt/mssql-tools18/bin => For sqlcmd
# - ~/.dotnet/tools => To access to installed dotnet tool (See https://github.com/dotnet/dotnet-docker/issues/520#issuecomment-388343613)
ENV PATH="${PATH}:~/.dotnet/tools:/opt/mssql-tools18/bin"

# Set the environment variable with the versions of the installed tools
RUN NODE_VERSION=$(node -v) && \
    echo "export NODE_VERSION=${NODE_VERSION}" >> ~/.bashrc
RUN NPM_VERSION=$(npm -v) && \
    echo "export NPM_VERSION=${NPM_VERSION}" >> ~/.bashrc
RUN SQLCMD_VERSION=$(sqlcmd --version | head -n 1) && \
    echo "export SQLCMD_VERSION=${SQLCMD_VERSION}" >> ~/.bashrc