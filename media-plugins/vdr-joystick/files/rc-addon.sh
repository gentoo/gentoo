# $Id$
#
# rc-addon plugin-startup-skript for vdr-joystick
#
# zulio <zulio(at)zulinux.net>

plugin_pre_vdr_start() {

	add_plugin_param "-d ${VDR_JOYSTICK_DEVICE:=/dev/js0}"
}

