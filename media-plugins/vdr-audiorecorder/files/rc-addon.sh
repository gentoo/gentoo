# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-audiorecorder/files/rc-addon.sh,v 1.2 2010/12/28 18:44:25 hd_brummy Exp $
#
# rc-addon-script for plugin audiorecorder
#
# Matthias Schwarzott <zzam@gentoo.org>

: ${AUDIORECORDER_DIR:=/var/vdr/audiorecorder}

plugin_pre_vdr_start() {
	add_plugin_param "--recdir=${AUDIORECORDER_DIR}"
	add_plugin_param "--debug=0"
}

