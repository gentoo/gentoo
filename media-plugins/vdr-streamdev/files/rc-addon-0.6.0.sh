# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-streamdev/files/rc-addon-0.6.0.sh,v 1.1 2013/03/31 16:22:06 hd_brummy Exp $
#
# rc-addon-script for plugin streamdev-server
#
# Joerg Bornkessel <hd_brummy@g.o>

plugin_pre_vdr_start() {

	: ${STREAMDEV_REMUX_SCRIPT:=/usr/share/vdr/streamdev/externremux.sh}
	add_plugin_param "-r ${STREAMDEV_REMUX_SCRIPT}"

	if yesno ${STREAMDEV_HTTP_AUTH_ENABLE:-no}; then

		if [[ -z ${STREAMDEV_HTTP_LOGIN} ]]; then
			eerror "No user in /etc/conf.d/vdr.streamdev-server"
			logger -t vdr "ERROR: need password for plugin vdr-streamdev-server"
		fi

		if [[ -z ${STREAMDEV_HTTP_PASSWORD} ]]; then
			eerror "No password in /etc/conf.d/vdr.streamdev-server"
			logger -t vdr "ERROR: need password for plugin vdr-streamdev-server"
		fi

		add_plugin_param "-a ${STREAMDEV_HTTP_LOGIN}:${STREAMDEV_HTTP_PASSWORD}"
	fi
}
