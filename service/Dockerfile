FROM golang:alpine AS builder

RUN apk add --no-cache git gcc libc-dev

WORKDIR /build/

COPY go.mod go.sum ./
RUN go get -u -d -v

COPY src src
WORKDIR /build/src
RUN go build -ldflags "-linkmode external -extldflags '-static'" -o /build/justdoit

FROM scratch

COPY --from=builder /build/justdoit /app/justdoit

CMD ["/app/justdoit"]