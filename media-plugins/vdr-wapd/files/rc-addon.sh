# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-wapd/files/rc-addon.sh,v 1.1 2008/01/27 17:42:03 hd_brummy Exp $
#
# rc-addon-script for plugin wapd
#
# Joerg Bornkessel hd_brummy@gentoo.org

plugin_pre_vdr_start() {

  add_plugin_param "-p ${WAPD_PORT:=8888}"
}
