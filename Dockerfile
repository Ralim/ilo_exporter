FROM golang as builder
ADD . /go/ilo_exporter/
WORKDIR /go/ilo_exporter
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -a -installsuffix cgo -o /go/bin/ilo_exporter

# Create the minimal image to run our executable.
FROM scratch

COPY --from=builder /go/bin/ilo_exporter /app/ilo_exporter
EXPOSE 9545

ENTRYPOINT ["/app/ilo_exporter"]
