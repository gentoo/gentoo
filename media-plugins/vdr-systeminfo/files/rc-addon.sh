# $Id$
#
# rc-addon-script for plugin systeminfo
#
# Joerg Bornkessel <hd_brummy@gentoo.org>

: ${SYSTEMINFO_SCRIPT:=/usr/share/vdr/systeminfo/systeminfo.sh}

plugin_pre_vdr_start() {

add_plugin_param "-s ${SYSTEMINFO_SCRIPT}"

}