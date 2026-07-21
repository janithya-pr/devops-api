# DevOps-api

To practice the DevOps process.

## Tech Stack

- Go 1.26
- Docker

## Requirements

- Go 1.25+
- Docker

## GitHub Repository

Name:        service name
Description: short descreption (ex: User profile and account management service.)
Visibility:  private
*no any other

## Project Structure

auth-service/
│
├── cmd/
│   └── api/
│       └── main.go
│
├── internal/
│   ├── db/
│   ├── handler/
│   ├── middleware/
│   ├── service/
│   └── router/
│
├── migrations/
│
├── Dockerfile
├── .dockerignore
├── .gitignore
├── go.mod
├── go.sum
└── README.md

## Dockerfile

FROM golang:1.25 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-s -w" \
    -o server \
    ./cmd/api

FROM alpine:3.22
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 8080
CMD ["./server"]
*can be more or less depending on the project





Test locally
docker build -t devops-api:latest .

Run it.

docker run \
-p 8080:8080 \
-e PROFILE_NAME=Janith \
-e PROFILE_TITLE=DevOps \
-e PROFILE_EMAIL=test@test.com \
-e PROFILE_PHONE=123456 \
devops-api

docker run -d -p 8080:8080 --name devops-api-app --restart unless-stopped devops-api:latest

docker run -d \
  --name devops-api \
  --restart unless-stopped \
  -p 8080:8080 \
  -e PROFILE_NAME="Janith" \
  -e PROFILE_TITLE="DevOps" \
  -e PROFILE_EMAIL="test@test.com" \
  -e PROFILE_PHONE="123456" \
  devops-api

docker stop devops-api
docker rm devops-api
docker rm -f devops-api
docker rmi devops-api
docker run --rm -p 8080:8080 devops-api

Test

http://localhost:8080/api/v1/profile

Builder
├── /app
│   ├── cmd
│   ├── internal
│   └── go.mod
└── /out
    └── server

Runtime
/
└── server