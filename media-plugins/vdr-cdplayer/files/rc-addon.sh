#
# rc-addon-script for plugin cdplayer
#
# $Id$

. /etc/conf.d/vdr.cdplayer

CDPLAYER_CACHE_DIR="${CDPLAYER_CACHE_DIR:=/var/cache/vdr/cdplayer}"

make_cachedir() {
	# check, is CDPLAYER_CACHE_DIR available
	if [ ! -d "${CDPLAYER_CACHE_DIR}" ]; then
		mkdir "${CDPLAYER_CACHE_DIR}"
		chown -R vdr:vdr "${CDPLAYER_CACHE_DIR}"
	fi
}

plugin_pre_vdr_start() {

	# default values
	add_plugin_param "-c cdplayer"
	add_plugin_param "-s cd.mpg"

	add_plugin_param "-d ${CDPLAYER_DEVICE:-/dev/cdrom}"

	if yesno ${CDPLAYER_CDDB_QUERY:-yes}; then

	add_plugin_param "-S ${CDPLAYER_CDDB_SERVER:=freedb.freedb.org}"

		if yesno ${CDPLAYER_CDDB_CACHE:-yes}; then
			# CDDB cache directory
			make_cachedir
			add_plugin_param "-C ${CDPLAYER_CACHE_DIR}"
		else
			# disable CDDB cache
			add_plugin_param "-N"
		fi

	else
		# disable CDDB request
		add_plugin_param "-n"

	fi
}
