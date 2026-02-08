FROM alpine:latest

RUN apk add --no-cache \
    curl \
    ca-certificates \
    git \
    openssh-client \
    bash \
    sudo \
    build-base \
    libstdc++

RUN adduser -D -s /bin/bash opencode && \
    echo 'opencode ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/opencode && \
    chmod 0440 /etc/sudoers.d/opencode

USER opencode
WORKDIR /home/opencode

ENV HOME=/home/opencode
ENV NVM_DIR=/home/opencode/.nvm
ENV PATH=$NVM_DIR/versions/node/v24.13.0/bin:/home/opencode/.npm-global/bin:$PATH

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install 24.13.0 && \
    npm config set prefix '/home/opencode/.npm-global' && \
    npm install -g opencode ohmyopencode && \
    npm cache clean --force

WORKDIR /app

CMD ["/bin/bash"]
