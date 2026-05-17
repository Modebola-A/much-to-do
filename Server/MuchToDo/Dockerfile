# ---- Build Stage ----
FROM golang:1.22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make

WORKDIR /app

# Copy dependency files first (better Docker layer caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN go build -o much-to-do ./cmd/api/main.go

# ---- Run Stage ----
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Copy only the binary from builder
COPY --from=builder /app/much-to-do .

# Expose the port the Gin server runs on
EXPOSE 8080

CMD ["./much-to-do"]
