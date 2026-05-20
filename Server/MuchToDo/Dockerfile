# ---- Build Stage ----
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git make

WORKDIR /app

# Allow Go 1.24 to build code requiring Go 1.25
ENV GOTOOLCHAIN=auto

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o much-to-do ./cmd/api/main.go

# ---- Run Stage ----
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=builder /app/much-to-do .

EXPOSE 8080

CMD ["./much-to-do"]
