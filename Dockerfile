FROM golang as builder
ADD . /go/ilo4_exporter/
WORKDIR /go/ilo4_exporter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo

FROM alpine:latest
ENV API_USERNAME ''
ENV API_PASSWORD ''
RUN apk --no-cache add ca-certificates bash
COPY --from=builder /go/ilo4_exporter/ilo4_exporter /app/ilo4_exporter
EXPOSE 9545
ENTRYPOINT /app/ilo4_exporter -api.username=$API_USERNAME -api.password=$API_PASSWORD
