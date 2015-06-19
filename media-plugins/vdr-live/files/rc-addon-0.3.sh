# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-live/files/rc-addon-0.3.sh,v 1.1 2015/01/28 14:56:35 hd_brummy Exp $
#
# zzam@g.o
# hd_brummy@g.o

EPGIMAGES_DIR="/var/cache/vdr/epgimages"

plugin_pre_vdr_start() {
	if [ "${LIVE_USE_SSL:=no}" = "yes" ]; then
		if [ -n "${LIVE_SSL_PORT}" ]; then
			add_plugin_param "-s ${LIVE_SSL_PORT}"
		fi

		add_plugin_param "--cert=/etc/vdr/plugins/live/live.pem"
		add_plugin_param "--key=/etc/vdr/plugins/live/live-key.pem"

	else
		if [ -n "${LIVE_PORT}" ]; then
			add_plugin_param "-p ${LIVE_PORT}"
		fi
	fi

	if [ -d ${EPGIMAGES_DIR} ]; then
		add_plugin_param "--epgimages=${EPGIMAGES_DIR}"
	fi

	local ip
	for ip in ${LIVE_BIND_IPS:=`hostname -i`}; do
		add_plugin_param "-i ${ip}"
	done
}
