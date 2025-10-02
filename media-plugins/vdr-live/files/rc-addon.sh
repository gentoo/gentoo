#
# zzam@g.o
# hd_brummy@g.o
# martin.dummer@gmx.net

plugin_pre_vdr_start() {
	if [ "${LIVE_USE_SSL:=no}" = "yes" ]; then
		if [ -n "${LIVE_SSL_PORT}" ]; then
			add_plugin_param "-s ${LIVE_SSL_PORT}"
		fi
		if [ -n "${LIVE_SSL_CERTFILE}" -a -n "${LIVE_SSL_KEYFILE}" ]; then
			add_plugin_param "--cert=${LIVE_SSL_CERTFILE}"
			add_plugin_param "--key=${LIVE_SSL_KEYFILE}"
		fi
	else
		add_plugin_param "-s 0"
	fi

	if [ -n "${LIVE_PORT}" ]; then
		add_plugin_param "-p ${LIVE_PORT}"
	fi

	if [ -d ${EPGIMAGES_DIR:=/var/cache/vdr/epgimages} ]; then
		add_plugin_param "--epgimages=${EPGIMAGES_DIR}"
	fi

	if [ -n "${LIVE_BIND_IPS}" ]; then
		local ip
		for ip in ${LIVE_BIND_IPS}; do
			add_plugin_param "-i ${ip}"
		done
	fi
}
