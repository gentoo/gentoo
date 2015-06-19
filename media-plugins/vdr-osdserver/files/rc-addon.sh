# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-osdserver/files/rc-addon.sh,v 1.1 2007/12/02 16:02:37 hd_brummy Exp $
#
# rc-addon plugin-startup-skript for vdr-osdserver
#
# zulio <zulio(at)zulinux.net>

plugin_pre_vdr_start() {

	add_plugin_param "-p ${OSDSERVER_PORT:=2010}"
}

