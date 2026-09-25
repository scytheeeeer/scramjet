FROM node:24-bookworm

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    binaryen \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install wasm-bindgen-cli

RUN git clone https://github.com/r58playz/wasm-snip.git /tmp/wasm-snip \
    && cd /tmp/wasm-snip \
    && cargo install --path .

WORKDIR /app

COPY . .

RUN corepack enable
RUN pnpm install --frozen-lockfile

RUN cd packages/core && pnpm rewriter:build && pnpm build
