# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-vdrmanager/files/rc-addon-0.12.sh,v 1.1 2014/06/01 17:09:08 hd_brummy Exp $
#
# rc-addon plugin-startup-skript for vdr-vdrmanager
#

: ${VDRMANAGER_PORT:=6420}

# default path from ebuild merge; no option in config file to overwrite
: ${VDRMANAGER_CERTFILE:=/etc/vdr/plugins/vdrmanager/vdrmanager.pem}

if [[ -z ${VDRMANAGER_PASS} ]]; then
	eerror "Empty password in /etc/conf.d/vdr.vdrmanager"
	logger -t vdr "ERROR: need password for plugin vdr-manager"
fi

plugin_pre_vdr_start() {

	add_plugin_param "-p${VDRMANAGER_PORT}"
	add_plugin_param "-P${VDRMANAGER_PASS}"

	if yesno ${SVDRPHOSTS_CHECK:-no}; then
		add_plugin_param "-s"
	fi

	add_plugin_param "-k ${VDRMANAGER_CERTFILE}"

	# vdrmanager_compression
	add_plugin_param "-c ${VDRMANAGER_COMPRESSION}"
}
