# $Id$
#
# rc-addon-script for plugin wapd
#
# Joerg Bornkessel hd_brummy@gentoo.org

plugin_pre_vdr_start() {

  add_plugin_param "-p ${WAPD_PORT:=8888}"
}
