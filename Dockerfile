# syntax=docker/dockerfile:1.8
# STAGE 1: Buildtime
FROM golang:1.26-alpine AS builder
RUN apk add --no-cache ca-certificates tzdata
# RUN apk add --no-cache ca-certificates tzdata git
WORKDIR /src
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w -buildid=" \
    -o /out/api ./cmd/api

# STAGE 2: Runtime
FROM gcr.io/distroless/static-debian12:nonroot AS runner
# FROM gcr.io/distroless/static-debian12:nonroot
# WORKDIR /app
COPY --from=builder /out/api /api
# COPY --from=builder /out/service ./service
# COPY --from=builder /main /main
# USER nonroot:nonroot
# USER 65534:65534
# EXPOSE 8080
ENTRYPOINT ["/api"]

# -----------------------------HEALTHCHECK---------------------------------
# # DISTROLESS HEALTHCHECK: Executed directly with no shell or wget needed
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#     CMD ["./service", "--health"]

# --------------------------------LABEL------------------------------------
# LABEL maintainer="your-team@example.com" \
#       application="your-microservice" \
#       version="1.0"

# ---------------------------------ARG-------------------------------------
# FROM --platform=$BUILDPLATFORM golang:1.26-alpine AS builder
# ...

# ARG TARGETOS
# ARG TARGETARCH
# RUN --mount=type=cache,target=/go/pkg/mod \
#     --mount=type=cache,target=/root/.cache/go-build \
#     CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \  or CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
#     go build -trimpath -ldflags="-s -w -buildid=" \
#     -o /app/service ./cmd/service
# ...