#
# rc-addon-script for plugin osdteletext
#
# $Id$

plugin_pre_vdr_start() {
	: ${GRAPHLCD_DIR:=/etc/vdr/plugins/graphlcd/graphlcd.conf}
	: ${GRAPHLCD_DISPLAY:=t6963c}

	add_plugin_param "-c ${GRAPHLCD_DIR}"
	add_plugin_param "-d ${GRAPHLCD_DISPLAY}"
}
