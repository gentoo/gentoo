# $Id$
#
# rc-addon plugin-startup-skript for vdr-osdserver
#
# zulio <zulio(at)zulinux.net>

plugin_pre_vdr_start() {

	add_plugin_param "-p ${OSDSERVER_PORT:=2010}"
}

