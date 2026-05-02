# ---- Stage 1: Build ----
FROM golang:1.24-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o app ./cmd/api

# ---- Stage 2: Run ----
FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache wget

RUN adduser -D appuser

COPY --from=builder /app/app .

COPY .env .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 \
    CMD wget -q -O- http://127.0.0.1:8080/health | grep -q "ok" || exit 1
CMD ["./app"]