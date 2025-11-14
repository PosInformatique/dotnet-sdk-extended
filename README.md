# dotnet-sdk-extended
Extended .NET SDK Docker image with sqlcmd, Node.js, and additional utilities

## Overview
dotnet-sdk-extended is a Docker image based on Microsoft’s [mcr.microsoft.com/dotnet/sdk](https://mcr.microsoft.com/en-us/product/dotnet/sdk/about). It adds commonly needed build-time tools so your .NET builds run faster and more reliably in CI.

Included tools:
- Node.js (with npm)
- sqlcmd (cross-platform)

Image registry:
- ghcr.io/posinformatique/dotnet-sdk-extended

## Why this image?
- Faster CI builds: downloading Node.js and sqlcmd during each pipeline run can take minutes. This image bakes them in to reduce setup time and flakiness.

## Tags
- Exact SDK versions:
  - [9.0.306](https://github.com/PosInformatique/dotnet-sdk-extended/pkgs/container/dotnet-sdk-extended/)
  - [9.0.307](https://github.com/PosInformatique/dotnet-sdk-extended/pkgs/container/dotnet-sdk-extended/)

## Tool versions
- Node.js: v22.20.0 (LTS)
- npm: 10.9.3
- sqlcmd: 1.5.0

## Environment variables
The image exposes the installed versions via:
- `NPM_VERSION`
- `NODE_VERSION`
- `SQLCMD_VERSION`

These can be inspected in your CI steps if needed.

## Usage in CI

### GitHub Actions
Replace the default job container with this image to build .NET apps and run Node/npm/sqlcmd without extra installs.

- Example 1: Use the floating major tag
```yaml
name: build

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/posinformatique/dotnet-sdk-extended:9.0
    steps:
      - uses: actions/checkout@v4
      - name: Check tool versions
        run: |
          echo "Node: $NODE_VERSION"
          echo "npm: $NPM_VERSION"
          echo "sqlcmd: $SQLCMD_VERSION"
      - name: Restore
        run: dotnet restore
      - name: Build
        run: dotnet build --configuration Release --no-restore
      - name: Test
        run: dotnet test --configuration Release --no-build --verbosity normal
```

- Example 2: Pin to an exact SDK version
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/posinformatique/dotnet-sdk-extended:9.0.306
    steps:
      - uses: actions/checkout@v4
      - run: dotnet build --configuration Release
```

### Azure Pipelines
Use the container at the job level to run your .NET build within this image.

- Example 1: Use the floating major tag
```yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

jobs:
- job: Build
  displayName: Build
  container: ghcr.io/posinformatique/dotnet-sdk-extended:9.0
  steps:
  - checkout: self
  - script: |
      echo "Node: $NODE_VERSION"
      echo "npm: $NPM_VERSION"
      echo "sqlcmd: $SQLCMD_VERSION"
    displayName: Check tool versions
  - script: dotnet restore
    displayName: Restore
  - script: dotnet build --configuration Release --no-restore
    displayName: Build
  - script: dotnet test --configuration Release --no-build --verbosity normal
    displayName: Test
```

- Example 2: Pin to an exact SDK version
```yaml
jobs:
- job: Build
  container: ghcr.io/posinformatique/dotnet-sdk-extended:9.0.306
  steps:
  - checkout: self
  - script: dotnet build --configuration Release
    displayName: Build
```

## Notes
- The base is the official .NET SDK image; only build-time tools are added.
- Prefer the exact tag (e.g., 9.0.306) for reproducible builds; use 9.0 for convenience and automatic updates within the major line.