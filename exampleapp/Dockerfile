# Stage 1: Build the Go application
FROM golang:1.23-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN go build -o webserver

# Stage 2: Create a lightweight image
FROM alpine:latest

# Set the working directory in the final image
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/webserver .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./webserver"]

