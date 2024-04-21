# ilo_exporter

[![Go Report Card](https://goreportcard.com/badge/github.com/ralim/ilo_exporter)](https://goreportcard.com/report/github.com/ralim/ilo_exporter)

Metrics exporter for HP iLO to prometheus.
This is forked from the version by MauveSoftware.

Changes from the fork:

- Metrics endpoints split into two {Chassis,System} to allow fetching at different update rates
- Port change to `9545` from the document `19545`
- Docker image builds for `x86_64` and `aarch64`
- Dramatically smaller docker images that just contain the binary
- Forwards API username/password from the prometheus query so its not in this containers env

## Install

```bash
go get -u github.com/ralim/ilo_exporter
```

## Usage

### Binary

```bash
./ilo_exporter
```

### Docker

```bash
docker run -d --restart always --name ilo_exporter -p 9545:9545 ghcr.io/ralim/ilo_exporter:main
```

## Prometheus configuration

To get metrics for 172.16.0.200 using <https://my-exporter-tld/metrics_system?hosts=172.16.0.200>
With an iLO authentication configured for

Username: `ilo_exporter`
Password: `g3tM3trics`

```bash
  - job_name: 'ilo'
    scrape_interval: 300s
    scrape_timeout: 120s
    scheme: https
    metrics_path: /metrics_system
    basic_auth:
      username: 'ilo_exporter'
      password: 'g3tM3trics'
    static_configs:
      - targets:
          - 172.16.0.200
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_host
      - source_labels: [__param_host]
        target_label: instance
        replacement: '${1}'
      - target_label: __address__
        replacement: my-exporter-tld
```

This can then be repeated for `metrics_chassis`. Note that chassis metrics are _much_ slower to poll on some systems, so you will need the slow timeout.

## Grafana

For users of [Grafana](https://grafana.com/), this repository includes an example [dashboard](iLO-grafana-dashboard.json) and example [alert rules](ilo-grafana-alerts.yaml).

## License

(c) Mauve Mailorder Software GmbH & Co. KG, 2022. Licensed under [MIT](LICENSE) license.

## Prometheus

see [Prometheus main site](ttps://prometheus.io/)
