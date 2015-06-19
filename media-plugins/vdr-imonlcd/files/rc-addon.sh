# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-imonlcd/files/rc-addon.sh,v 1.3 2011/01/28 23:14:02 idl0r Exp $

plugin_pre_vdr_start() {
	add_plugin_param "${IMONLCD_DEVICE:+--device ${IMONLCD_DEVICE}}"
	add_plugin_param "${IMONLCD_PROTOCOL:+--protocol ${IMONLCD_PROTOCOL}}"
}
