# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-systeminfo/files/rc-addon.sh,v 1.1 2008/11/17 17:56:13 hd_brummy Exp $
#
# rc-addon-script for plugin systeminfo
#
# Joerg Bornkessel <hd_brummy@gentoo.org>

: ${SYSTEMINFO_SCRIPT:=/usr/share/vdr/systeminfo/systeminfo.sh}

plugin_pre_vdr_start() {

add_plugin_param "-s ${SYSTEMINFO_SCRIPT}"

}