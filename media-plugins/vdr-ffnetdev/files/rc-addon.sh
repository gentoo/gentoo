# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-ffnetdev/files/rc-addon.sh,v 1.3 2009/06/13 09:57:49 zzam Exp $
#
# rc-addon-script for plugin ffnetdev
#
# Joerg Bornkessel <hd_brummy@gentoo.org>

: ${VNC_PORT:=20001}
: ${TS_PORT:=20002}

plugin_pre_vdr_start() {

  [ "${USE_VNC}" = "yes" ] && add_plugin_param "-o ${VNC_PORT}"

  [ "${USE_TS}" = "yes" ] && add_plugin_param "-t  ${TS_PORT}"

  [ "${REMOTE}" = "yes" ] && add_plugin_param "-e"

  return 0
}
