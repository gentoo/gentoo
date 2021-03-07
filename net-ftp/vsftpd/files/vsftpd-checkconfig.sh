#!/bin/sh

VSFTPD_CONF="${VSFTPD_CONF:-/etc/vsftpd/vsftpd.conf}"

if [ ! -e ${VSFTPD_CONF} ] ; then
	echo "Please setup ${VSFTPD_CONF} before starting vsftpd" >&2
	echo "There are sample configurations in /usr/share/doc/vsftpd" >&2
	exit 1
fi

if egrep -iq "^ *background *= *yes" "${VSFTPD_CONF}" ; then
	echo "${VSFTPD_CONF} must not set background=YES" >&2
	exit 1
fi

has_ip=false has_ipv6=false ip_error=true
egrep -iq "^ *listen *= *yes" "${VSFTPD_CONF}" && has_ip=true
egrep -iq "^ *listen_ipv6 *= *yes" "${VSFTPD_CONF}" && has_ipv6=true
if ${has_ip} && ! ${has_ipv6} ; then
	ip_error=false
elif ! ${has_ip} && ${has_ipv6} ; then
	ip_error=false
fi
if ${ip_error} ; then
	echo "${VSFTPD_CONF} must contain listen=YES or listen_ipv6=YES" >&2
	echo "but not both" >&2
	exit 1
fi

