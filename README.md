[![](https://images.microbadger.com/badges/image/rawmind/alpine-go-dnsmasq.svg)](https://microbadger.com/images/rawmind/alpine-go-dnsmasq "Get your own image badge on microbadger.com")


alpine-go-dnsmasq 
=================

This image is the go-dnsmasq base. It comes from [alpine-monit][alpine-monit].

## Build

```
docker build -t rawmind/alpine-go-dnsmasq:<version> .
```

## Versions

- `1.0.6-1` [(Dockerfile)](https://github.com/rawmind0/alpine-go-dnsmasq/blob/1.0.6-1/Dockerfile)

## Configuration

This image runs [go-dnsmasq][go-dnsmasq] with monit. go-dnsmasq is started with user and group "go-dnsmasq".

Besides, you can customize the configuration in several ways:

### Default Configuration

Etcd is installed with the default configuration and some parameters can be overrided with env variables:

- DNSMASQ_LISTEN="0.0.0.0:53"					# Address to bind
- DNSMASQ_SEARCH_DOMAINS="rancher.internal"		# Search domains. Multiple values with , separator 
- DNSMASQ_ENABLE_SEARCH="True"					# Enable search feature
- DNSMASQ_SERVERS="8.8.8.8:53,8.8.4.4:53"		# Dns forwarders
- DNSMASQ_FWD_NDOTS="0"							# Number of dots a name must have before the query is forwarded
- DNSMASQ_NDOTS="1"								# Number of dots a name must have before making an initial absolute query 
- DNSMASQ_NOREC="False"							# Disable forwarding of queries to upstream nameservers
- DNSMASQ_RCACHE="0"							# Capacity of the response cache. (‘0‘ disables caching)
- DNSMASQ_RR="True"								# Enable round robin of A/AAAA records
- DNSMASQ_VERBOSE="True"						# Enable verbose logging
- STUB_ZONES="rancher.internal/169.254.169.250"	# Use different nameservers for given domains. Multiple values with , separator


### Custom Configuration

go-dnsmasq is installed under /opt/go-dnsmasq and make use of /opt/go-dnsmasq/bin/go-dnsmasq-source.sh to generate /opt/go-dnsmasq/etc/skydns-source source env variables.

You can edit this files in order customize configuration


[alpine-monit]: https://github.com/rawmind0/alpine-monit/
[go-dnsmasq]: https://github.com/janeczku/go-dnsmasq

