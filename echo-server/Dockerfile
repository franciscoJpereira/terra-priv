FROM golang:1.24

WORKDIR /server

COPY echo-server/main.go main.go
RUN go build -v -o /usr/local/bin/echo_server main.go

CMD [ "echo_server" ]