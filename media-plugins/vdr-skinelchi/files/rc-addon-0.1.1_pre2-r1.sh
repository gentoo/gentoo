# $Id$
#
# rc-addon plugin-startup-skript for vdr-skinelchi
#
# This sript is called by gentoo-vdr-scripts on start of VDR

# Check on dxr-3 and set default logo DIR
plugin_pre_vdr_start() {

# Next lines commented, not supported yet, remove this if dxr3 logo support is available
#	if [ "${PLUGINS#*dxr3}" != "${PLUGINS}" ] ; then
#		: ${SKINELCHI_LOGOS_DIR:=/usr/share/vdr/channel-logos/logos-dxr3}
#	else
		: ${SKINELCHI_LOGOS_DIR:=/usr/share/vdr/channel-logos}
#	fi
  
	add_plugin_param "-l ${SKINELCHI_LOGOS_DIR}"

}
