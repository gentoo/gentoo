plugin_pre_vdr_start() {
	if [ -n "${LIVE_PORT}" ]; then
		add_plugin_param "-p ${LIVE_PORT}"
	fi

	local ip
	for ip in ${LIVE_BIND_IPS}; do
		add_plugin_param "-i ${ip}"
	done
}

