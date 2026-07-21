# Stage 1: Build
FROM golang:1.26-bookworm AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w -buildid=" \
    -o /out/server ./cmd/api

# Stage 2: Runtime
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /out/server /server

EXPOSE 8080

ENTRYPOINT ["/server"]