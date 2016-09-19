#!/usr/bin/env bash

cat << EOF > ${SERVICE_CONF}
#!/usr/bin/env bash

export STUB_ZONES=\${STUB_ZONES:-"rancher.internal/169.254.169.250"}
export DNSMASQ_LISTEN=\${DNSMASQ_LISTEN:-"0.0.0.0:53"}
export DNSMASQ_ENABLE_SEARCH=\${DNSMASQ_ENABLE_SEARCH:-"true"}
if [ "\${DNSMASQ_ENABLE_SEARCH}" == "false" ]; then
	export DNSMASQ_SEARCH_DOMAINS="" 
else
	DNSMASQ_SEARCH_DOMAINS=\${DNSMASQ_SEARCH_DOMAINS:-""}
	for i in \$(echo \${STUB_ZONES} | sed -e s'/,/ /g'); do 
		domain=\$(echo \$i | cut -d"/" -f1; done)
		if [ \$(echo \${DNSMASQ_SEARCH_DOMAINS} | grep -w \${domain} &> /dev/null ; echo \$?) -eq 1 ]; then
			if [ "\${DNSMASQ_SEARCH_DOMAINS}" == "" ]; then 
				DNSMASQ_SEARCH_DOMAINS=\${domain}
			else
				DNSMASQ_SEARCH_DOMAINS=\${DNSMASQ_SEARCH_DOMAINS},\${domain}
			fi
		fi
	done	
   	export DNSMASQ_SEARCH_DOMAINS
fi
export DNSMASQ_FWD_NDOTS=\${DNSMASQ_FWD_NDOTS:-"0"}
export DNSMASQ_NDOTS=\${DNSMASQ_NDOTS:-"0"}
export DNSMASQ_NOREC=\${DNSMASQ_NOREC:-"false"}
export DNSMASQ_RCACHE=\${DNSMASQ_RCACHE:-"0"}
export DNSMASQ_RR=\${DNSMASQ_RR:-"True"}
export DNSMASQ_VERBOSE=\${DNSMASQ_VERBOSE:-"true"}
if [ "\${DNSMASQ_NOREC}" == "true" ]; then
	export DNSMASQ_SERVERS="" 
else
   	export DNSMASQ_SERVERS=\${DNSMASQ_SERVERS:-"8.8.8.8:53,8.8.4.4:53"} 
fi
EOF
