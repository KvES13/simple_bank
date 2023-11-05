#Build stage
FROM golang:1.21.3-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o bank ./cmd/main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

#Run stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/bank .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080

CMD [ "/app/bank" ]
ENTRYPOINT ["/app/start.sh"]