# $Id$
#
# rc-addon plugin-startup-skript for vdr-dvd
#

plugin_pre_vdr_start() {

	: ${DVD_DRIVE:=/dev/dvd}

	add_plugin_param "-C${DVD_DRIVE}"
	add_plugin_param "--dvd=${DVD_DRIVE}"

	if [ "${DVD_DVDCSS:=no}" = "yes" ]; then
		export DVDCSS_METHOD=key
	fi
}
