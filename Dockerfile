# ---- Base image ----
FROM node:22-alpine AS base
WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# ---- Dependencies layer ----
FROM base AS deps

# Copy workspace files
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json turbo.json ./

# Copy packages and apps structure
COPY apps ./apps
COPY packages ./packages

# Install dependencies
RUN pnpm install --frozen-lockfile

# ---- Build layer ----
FROM deps AS builder

RUN pnpm turbo run build

# ---- Production image ----
FROM node:22-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy built files
COPY --from=builder /app ./

EXPOSE 3000

CMD ["pnpm", "start"]