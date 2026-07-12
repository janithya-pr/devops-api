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

## .dockerignore

## .gitignore

#Binaries
bin/
dist/

#Coverage
coverage.out
*.coverprofile

#Environment files
.env
.env.*

#IDE
.vscode/
.idea/

#OS files
.DS_Store
Thumbs.db
*can be more or less depending on the project

## Running

```bash
go mod init github.com/janithya-pr/devops-api
go mod tidy
go run ./cmd/api

git init

# Create your project locally
mkdir auth-service
cd auth-service

git init

go mod init github.com/yourusername/auth-service

git add .
git commit -m "Initial commit"

git branch -M main
git remote add origin git@github.com:yourusername/auth-service.git
git push -u origin main