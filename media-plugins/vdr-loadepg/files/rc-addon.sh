# $Id$
#
# rc-addon-script for plugin loadepg
#
# Joerg Bornkessel hd_brummy@gentoo.org 
# Gentoo-VDR-Project vdr@gentoo.org
# 

LOADEPG_CONFDIR="/etc/vdr/plugins/loadepg"

plugin_pre_vdr_start() {

	add_plugin_param "-c ${LOADEPG_CONFDIR}"
}

