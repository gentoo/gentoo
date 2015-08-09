# $Id$

plugin_pre_vdr_start() {
	add_plugin_param "${IMONLCD_DEVICE:+--device ${IMONLCD_DEVICE}}"
	add_plugin_param "${IMONLCD_PROTOCOL:+--protocol ${IMONLCD_PROTOCOL}}"
}
