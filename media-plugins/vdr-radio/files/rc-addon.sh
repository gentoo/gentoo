#
# rc-addon plugin-startup-skript for vdr-radio
# 
# This sript is called by gentoo-vdr-scripts on start of VDR
#
# Joerg Bornkessel <hd_brummy@astrali.de>

# Set default DIR to the background picture
RADIO_BACKGROUND_DIR=/usr/share/vdr/radio
# Set default DIR for cache
RADIO_TMP_DIR=/var/cache/vdr-radio

_make_cachedir() {
	if [ ! -e "${RADIO_TMP_DIR}" ]; then
		mkdir "${RADIO_TMP_DIR}"
		chown -R vdr:vdr "${RADIO_TMP_DIR}"
	fi
}

_make_cachedir

plugin_pre_vdr_start() {

	add_plugin_param "-f ${RADIO_BACKGROUND_DIR}"
	add_plugin_param "-d ${RADIO_TMP_DIR}"
}
