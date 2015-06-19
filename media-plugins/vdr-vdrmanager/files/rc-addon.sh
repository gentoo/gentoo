# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-vdrmanager/files/rc-addon.sh,v 1.5 2012/12/02 08:39:56 hd_brummy Exp $
#
# rc-addon plugin-startup-skript for vdr-vdrmanager
#

: ${VDRMANAGER_PORT:=6420}

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
}

