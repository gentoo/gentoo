# $Id$
#
# rc-addon plugin-startup-skript for vdr-skinsoppalusikka
#
# This sript is called by gentoo-vdr-scripts on start of VDR

# Check if dxr3 plugin in /etc/conf.d/vdr Plugins=""
# and set default logo DIR

plugin_pre_vdr_start() {

	if [ "${PLUGINS}" != "${PLUGINS#*dxr3}" ] ; then
		: ${SKINSOPPALUSIKKA_LOGOS_DIR:=/usr/share/vdr/skinsoppalusikka/logos-dxr3}
	else
		: ${SKINSOPPALUSIKKA_LOGOS_DIR:=/usr/share/vdr/channel-logos}
	fi
  
	add_plugin_param "-l ${SKINSOPPALUSIKKA_LOGOS_DIR}"

}
