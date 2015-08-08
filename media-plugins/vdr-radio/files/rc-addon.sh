# $Id$
#
# rc-addon plugin-startup-skript for vdr-radio
# 
# This sript is called by gentoo-vdr-scripts on start of VDR

# Set default DIR to the background picture
RADIO_BACKGROUND_DIR=/usr/share/vdr/radio

plugin_pre_vdr_start() {

    add_plugin_param "-f ${RADIO_BACKGROUND_DIR}"

}
