alpine-go-dnsmasq 
=================

This image is the go-dnsmasq base. It comes from [alpine-monit][alpine-monit].

## Build

```
docker build -t rawmind/alpine-go-dnsmasq:<version> .
```

## Versions

- `1.0.6` [(Dockerfile)](https://github.com/rawmind0/alpine-go-dnsmasq/blob/2.5.3-4/Dockerfile)

## Configuration

This image runs [go-dnsmasq][go-dnsmasq] with monit. go-dnsmasq is started with user and group "go-dnsmasq".

Besides, you can customize the configuration in several ways:

### Default Configuration

Etcd is installed with the default configuration and some parameters can be overrided with env variables:

- DNSMASQ_LISTEN=${DNSMASQ_LISTEN:-"0.0.0.0:53"}
- DNSMASQ_SEARCH_DOMAINS=${DNSMASQ_SEARCH_DOMAINS:-"dev.local"}
- DNSMASQ_ENABLE_SEARCH=${DNSMASQ_ENABLE_SEARCH:-"True"}
- DNSMASQ_SERVERS=${DNSMASQ_SERVERS:-"8.8.8.8:53,8.8.4.4:53"}
- DNSMASQ_FWD_NDOTS=${DNSMASQ_FWD_NDOTS:-"0"}
- DNSMASQ_NDOTS=${DNSMASQ_NDOTS:-"1"}
- DNSMASQ_RCACHE=${DNSMASQ_RCACHE:-"0"}
- DNSMASQ_RR=${DNSMASQ_RR:-"True"}
- DNSMASQ_VERBOSE=${DNSMASQ_VERBOSE:-"True"}
- STUB_ZONES=${STUB_ZONES:-"rancher.internal/169.254.169.250"}


### Custom Configuration

go-dnsmasq is installed under /opt/go-dnsmasq and make use of /opt/go-dnsmasq/bin/go-dnsmasq-source.sh to source env variables.

You can edit this files in order customize configuration


[alpine-monit]: https://github.com/rawmind0/alpine-monit/
[go-dnsmasq]: https://github.com/janeczku/go-dnsmasq

