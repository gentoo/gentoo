# $Id$
#
# rc-addon-script for plugin audiorecorder
#
# Matthias Schwarzott <zzam@gentoo.org>

: ${AUDIORECORDER_DIR:=/var/vdr/audiorecorder}

plugin_pre_vdr_start() {
	add_plugin_param "--recdir=${AUDIORECORDER_DIR}"
	add_plugin_param "--debug=0"
}

