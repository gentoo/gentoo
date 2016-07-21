# $Id$
#
# rc-addon plugin-startup-skript for vdr-launcher
#

plugin_pre_vdr_start() {
	local p
	for p in ${VDR_LAUNCHER_EXCLUDE}; do
		add_plugin_param "-x ${p}"
	done
}
