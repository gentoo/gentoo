# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvd/files/rc-addon.sh,v 1.3 2012/12/16 19:33:31 hd_brummy Exp $
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
