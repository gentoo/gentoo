#!/usr/bin/env bash
#

set -e

. /etc/default/derper

if [[ -z ${DERPER_USER} ]]; then
	echo "DERPER_USER is not set via /etc/default/derper" >&2
	exit 1
fi

if [[ -z ${CERTDIR} ]]; then
	eval "CERTDIR=~${_user}/.cache/tailscale/derper-certs"
	echo "CERTDIR is not set, fallback to default '${CERTDIR}' directory" >&2
fi

if [[ ! -e ${CERTDIR} ]]; then
	mkdir -m 750 -p ${CERTDIR}
	chown ${DERPER_USER}${DERPER_GROUP:+:}${DERPER_GROUP} ${CERTDIR}
fi

# according to: https://github.com/tailscale/tailscale/blob/651e0d8aad1e97df71ac09ee25274377995133dd/cmd/derper/cert.go#L63
parse_hostname() {
	local hn="${1}"
	while [[ ${hn} =~ (.*)[^a-zA-Z0-9\.-]+(.*) ]]; do
		hn=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
	done
	echo -n ${hn}
}

cp_cert() {
	local suffix=".crt" mode=640 var="CERTFILE"
	if [[ ${FUNCNAME[1]} == cp_key ]]; then
		suffix=".key"
		mode=600
		var="KEYFILE"
	fi

	if [[ -z ${HOSTNAME} ]]; then
		echo "${var} is set while HOSTNAME is not, ignore ${var}" >&2
	else
		local file="${CERTDIR%/}/$(parse_hostname ${HOSTNAME})${suffix}"
		cp -f -L ${!var} ${file}
		chown ${DERPER_USER}${DERPER_GROUP:+:}${DERPER_GROUP} ${file}
		chmod ${mode} ${file}
	fi
}

cp_key() {
	cp_cert
}

if [[ -n ${CERTFILE} ]]; then
	cp_cert
fi
if [[ -n ${KEYFILE} ]]; then
	cp_key
fi
