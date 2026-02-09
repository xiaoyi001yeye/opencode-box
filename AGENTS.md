# AGENTS.md

## Project Overview

This repository contains a Dockerfile for building an Alpine-based Docker image with OpenCode and Node.js v24.13.0. The image is optimized for running OpenCode in a containerized environment.

## Build Commands

### Build the Docker image
```bash
docker build -t opencode-box .
```

### Run the container
```bash
docker run -it --rm -v $(pwd):/app opencode-box
```

### Interactive container access
```bash
docker run -it --rm -v $(pwd):/app --entrypoint /bin/bash opencode-box
```

## Docker Guidelines

### Base Image
- Always use `alpine:latest` for minimal image size
- When pinning Alpine versions, use semantic versioning (e.g., `alpine:3.19`)

### Package Management
- Use `apk add --no-cache` to avoid caching indexes and reduce image layers
- Group related packages in single RUN commands to minimize layers
- Clean up unnecessary files and caches in the same RUN layer

### Layer Optimization
- Combine RUN commands where logically related
- Order commands from most-to-least frequently changing
- Place Dockerfile instructions in this order:
  1. FROM
  2. ENV (environment variables)
  3. RUN (package installation)
  4. WORKDIR
  5. COPY
  6. CMD/ENTRYPOINT

### User Management
- Never run containers as root
- Use `adduser -D` (Alpine) or `useradd` (Debian/Ubuntu)
- Configure sudo only when absolutely necessary
- Use `chmod 0440` for sudoers.d files

### Node.js Management
- Use nvm for version management instead of apk packages
- Pin Node.js versions precisely (e.g., `v24.13.0` not just `24`)
- Set NVM_DIR environment variable explicitly
- Configure npm global prefix to user home directory
- Clean npm cache with `npm cache clean --force`

### Environment Variables
- Define environment variables before commands that use them
- Use absolute paths for NVM_DIR and other tool directories
- Include global npm bin directory in PATH
- Use specific version paths instead of wildcards (e.g., `$NVM_DIR/versions/node/v24.13.0/bin`)

### Image Size Reduction
- Use `--no-cache` with apk
- Clean npm caches after installations
- Remove temporary files in same RUN layer
- Avoid unnecessary packages (e.g., `build-base` only when needed)

### Security
- Use `curl -fsSL` for downloads (fail silently, follow redirects)
- Verify package signatures when possible
- Keep base images updated
- Run as non-root user with minimal privileges

### Command Patterns
- Combine related commands with `&&`
- Use backslashes for multi-line commands
- Comment each logical group of operations
- Ensure proper quoting for paths with spaces

## File Structure

- `Dockerfile` - Main image definition
- `README.md` - Usage documentation in Chinese

## Testing

### Verify Node.js installation
```bash
node -v  # Should output v24.13.0
npm -v
```

### Verify OpenCode installation
```bash
opencode --version
```

### Verify OpenCode installation
```bash
which opencode
npm list -g opencode
```

## Adding New Packages

### System packages (apk)
Add to the first RUN command:
```dockerfile
RUN apk add --no-cache \
    curl \
    ca-certificates \
    <new-package>
```

### npm packages
Add to the npm install command:
```dockerfile
npm install -g opencode <new-package>
```

### Build dependencies
If packages require compilation, ensure `build-base` and `libstdc++` are installed.

## Version Updates

When updating Node.js:
1. Change version in `nvm install` command
2. Update PATH to new version directory
3. Test all npm packages work with new version

When updating packages:
1. Update version numbers
2. Test image build
3. Verify functionality

## Documentation

- Keep README.md in sync with Dockerfile changes
- Update Chinese documentation for Chinese users
- Document any breaking changes in commit messages

## Common Issues

### "npm not found"
- Ensure Node.js PATH is correct
- Verify nvm installation completed

### Permission denied
- Check user creation and sudoers configuration
- Verify file permissions on copied files

### Large image size
- Clean caches
- Remove unnecessary packages
- Use .dockerignore if applicable

## Commit Message Style

- Use present tense: "Add package" not "Added package"
- Capitalize subject line
- No period at end of subject line
- Reference issues if applicable
