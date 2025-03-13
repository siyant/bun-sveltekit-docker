# Use the official Bun image
FROM oven/bun:1 AS builder
WORKDIR /app

# Install dependencies
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the application
ENV NODE_ENV=production
RUN bun run build

# Production stage
FROM oven/bun:1-slim
WORKDIR /app

# Copy production dependencies and built application from builder
COPY --from=builder /app/package.json .
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["bun", "run", "build/index.js"]
