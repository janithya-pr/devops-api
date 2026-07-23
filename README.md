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

docker build -t devops-api:v1.0.0 .
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 456107725475.dkr.ecr.ap-southeast-1.amazonaws.com
docker tag devops-api:v1.0.0 456107725475.dkr.ecr.ap-southeast-1.amazonaws.com/devops-api:v1.0.0
docker push 456107725475.dkr.ecr.ap-southeast-1.amazonaws.com/devops-api:v1.0.0

docker tag devops-api:v1.0.0 456107725475.dkr.ecr.ap-southeast-1.amazonaws.com/devops-api:latest
docker push 456107725475.dkr.ecr.ap-southeast-1.amazonaws.com/devops-api:latest
<your-account-id>.dkr.ecr.<region>.amazonaws.com/devops-api:latest

One microservice = One Git repository (often, though some teams use a monorepo).
One microservice = One Docker image.
One Docker image = One ECR repository.
One ECS/Fargate service = Runs one Docker image from one ECR repository.

| Resource        |                                          Quantity |
| --------------- | ------------------------------------------------: |
| ECS Cluster     |                             **1 per environment** |
| ECS Service     |                            **1 per microservice** |
| Task Definition |                            **1 per microservice** |
| ECR Repository  |                            **1 per microservice** |
| Docker Image    |                            **1 per microservice** |
| Fargate Tasks   | **One or more per service**, depending on scaling |


GitHub
     │
     ▼
Docker Image
     │
     ▼
Container Registry
     │
     ├── AWS → Amazon ECR
     ├── GCP → Artifact Registry
     └── Azure → Azure Container Registry
     │
     ▼
Container Orchestrator
     │
     ├── ECS/Fargate
     ├── GKE
     ├── AKS
     └── Kubernetes

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