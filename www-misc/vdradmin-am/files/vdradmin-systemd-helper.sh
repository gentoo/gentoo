#!/bin/sh

# VDRADMIN helper script for configuration transfer from gentoo config file
# to a systemd service env file

# read config file
. /etc/conf.d/vdradmin

SYSTEMD_ENV_FILE="/etc/vdradmin/vdradmin-systemd.env"
SYSTEMD_ENV_TMP=$(mktemp)

DAEMON_OPTS=""

if [ "${SSL:=no}" = "yes" ]; then
	DAEMON_OPTS="--ssl"
fi

if [ "${IPV6:=no}" = "yes" ]; then
	DAEMON_OPTS="${DAEMON_OPTS} --ipv6"
fi

if [ "${LOGGING:=no}" = "yes" ]; then
	DAEMON_OPTS="${DAEMON_OPTS} --log ${LOGLEVEL:=4} --logfile /var/log/vdradmin/vdradmind.log"
fi

echo "# systemd environment file, created by pre-exec script, do not edit!" > ${SYSTEMD_ENV_TMP}
echo "CONF_D_OPTS=\"${DAEMON_OPTS}\"" >> ${SYSTEMD_ENV_TMP}

# compare env file for changes
diff -q ${SYSTEMD_ENV_TMP} ${SYSTEMD_ENV_FILE} >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "vdradmin-am configuration changed"
	cat ${SYSTEMD_ENV_TMP}
	mv ${SYSTEMD_ENV_TMP} ${SYSTEMD_ENV_FILE}
	chmod 0644 ${SYSTEMD_ENV_FILE}
	sudo systemctl daemon-reload
else
	echo "vdradmin-am configuration not changed"
	rm -f ${SYSTEMD_ENV_TMP} >/dev/null 2>&1
fi
