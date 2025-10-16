ARG DOTNET_SDK_VERSION=9.0

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_SDK_VERSION}

# Install sqlcmd
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y sqlcmd && \
    apt-get install -y git vim wget unzip jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add sqlcmd to PATH (already in /opt/mssql-tools18/bin by default)
ENV PATH="${PATH}:/opt/mssql-tools18/bin"

# Set the environment variable with the versions of the installed tools
RUN SQLCMD_VERSION=$(sqlcmd "-?" | grep -oP 'Version v\K[0-9.]+') && \
    echo "export SQLCMD_VERSION=${SQLCMD_VERSION}" >> ~/.bashrc