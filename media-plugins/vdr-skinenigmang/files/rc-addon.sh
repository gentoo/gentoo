# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-skinenigmang/files/rc-addon.sh,v 1.2 2007/04/17 12:41:34 zzam Exp $
#
# rc-addon-script for plugin skinenigmang
#
# Joerg Bornkessel hd_brummy@gentoo.org

SKINENIGMANG_LOGODIR="/usr/share/vdr/skinenigmang"

plugin_pre_vdr_start() {

  add_plugin_param "-l ${SKINENIGMANG_LOGODIR}"
}
