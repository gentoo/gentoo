# $Id$
#
# rc-addon-script for plugin graphtft & graphtft-fe
#
# Joerg Bornkessel <hd_brummy@g.o>

. /etc/conf.d/vdr.graphtft

plugin_pre_vdr_start() {

		: ${GRAPHTFT_DEVICE:=/dev/fb0}

		add_plugin_param "-d ${GRAPHTFT_DEVICE}"
}
