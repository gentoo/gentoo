#
# rc-addon-script for plugin osdteletext
#
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-graphlcd/files/rc-addon.sh,v 1.2 2007/04/17 12:39:30 zzam Exp $

plugin_pre_vdr_start() {
	: ${GRAPHLCD_DIR:=/etc/vdr/plugins/graphlcd/graphlcd.conf}
	: ${GRAPHLCD_DISPLAY:=t6963c}

	add_plugin_param "-c ${GRAPHLCD_DIR}"
	add_plugin_param "-d ${GRAPHLCD_DISPLAY}"
}
