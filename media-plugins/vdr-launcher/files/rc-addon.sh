# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-launcher/files/rc-addon.sh,v 1.2 2007/04/17 12:41:59 zzam Exp $
#
# rc-addon plugin-startup-skript for vdr-launcher
#

plugin_pre_vdr_start() {
	local p
	for p in ${VDR_LAUNCHER_EXCLUDE}; do
		add_plugin_param "-x ${p}"
	done
}
