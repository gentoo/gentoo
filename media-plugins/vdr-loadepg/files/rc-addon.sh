# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-loadepg/files/rc-addon.sh,v 1.2 2007/04/17 12:44:16 zzam Exp $
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

