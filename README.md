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
# Connect GitHub SSH
ssh-keygen -t ed25519 -C "your_email@example.com"

# start the ssh-agent in the background
Get-Service -Name ssh-agent | Set-Service -StartupType Manual  # or Automatic
# or
Get-Service ssh-agent
Start-Service ssh-agent

ssh-add $HOME\.ssh\id_ed25519
ssh-add -l  # chek all krys

# if have more than one github accounts
# create
C:\Users\USER\.ssh\config
# open
notepad $HOME\.ssh\config
# add
"# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes"

Get-Content $HOME\.ssh\id_ed25519.pub  # copy and add to github
ssh -T git@github.com  # retun the success

# Create your project locally and push
mkdir reponame  # or your service name
cd reponame     # or your service name

go mod init github.com/yourusername/reponame  # or your service name
go mod tidy

git init

git add .  # or internal/user/service.go
git commit -m "Initial commit"  # or "Initial project setup"
git status

git branch -M main
git branch

# add origin
git remote add origin git@github.com:yourusername/reponame.git
# ceck origin
git remote -v
# remove origin
git remote remove origin

git push -u origin main  # or another branch
git push  # we can use after the first push

# Use repo already created and branching
git clone git@github.com:company/reponame.git
cd reponame

git branch            # check current branch
git pull origin main  # or develop

# create branch
git checkout -b feature/feature-changing  # or git switch -c feature/user-authentication
git branch # check current branch

git add internal/auth/service.go # sometimes git add .
git commit -m "Add JWT authentication middleware"
git push -u origin feature/user-authentication
git push  # we can use after the first push

# update local main
git checkout main
git pull origin main

# delete feature branch
git branch -d feature/user-authentication             # locally
git push origin --delete feature/user-authentication  # on github












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







.git
.github
.gitignore
*.md
Dockerfile
.dockerignore
bin/
tmp/
dist/
vendor/
*.test
*.log
.env
.env.*
.vscode
.idea