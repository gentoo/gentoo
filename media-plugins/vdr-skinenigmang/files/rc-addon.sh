# $Id$
#
# rc-addon-script for plugin skinenigmang
#
# Joerg Bornkessel hd_brummy@gentoo.org

SKINENIGMANG_LOGODIR="/usr/share/vdr/skinenigmang"

plugin_pre_vdr_start() {

  add_plugin_param "-l ${SKINENIGMANG_LOGODIR}"
}
