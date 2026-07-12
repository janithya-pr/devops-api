# syntax=docker/dockerfile:1.7

############################
# Builder
############################
FROM golang:1.25-alpine AS builder

WORKDIR /src

# Required for HTTPS requests during build
RUN apk add --no-cache ca-certificates

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

# Build static binary
RUN CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    go build \
        -trimpath \
        -ldflags="-s -w -buildid=" \
        -o /out/server \
        ./cmd/api


############################
# Runtime
############################
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /out/server /server

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/server"]






# # syntax=docker/dockerfile:1.7

# ############################
# # Builder
# ############################
# FROM golang:1.25-alpine AS builder

# WORKDIR /src

# # CA certificates are required for HTTPS during build.
# RUN apk add --no-cache ca-certificates

# # Download dependencies first (better Docker layer caching).
# COPY go.mod go.sum ./

# RUN --mount=type=cache,target=/go/pkg/mod \
#     go mod download

# # Copy application source.
# COPY . .

# # Build cache speeds up incremental builds in CI.
# RUN --mount=type=cache,target=/root/.cache/go-build \
#     CGO_ENABLED=0 \
#     GOOS=linux \
#     go build \
#         -trimpath \
#         -ldflags="-s -w -buildid=" \
#         -o /out/server \
#         ./cmd/api

# ############################
# # Runtime
# ############################
# FROM gcr.io/distroless/static-debian12:nonroot

# COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# COPY --from=builder /out/server /server

# EXPOSE 8080

# USER nonroot:nonroot

# ENTRYPOINT ["/server"]