# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-joystick/files/rc-addon.sh,v 1.1 2007/12/03 20:47:02 hd_brummy Exp $
#
# rc-addon plugin-startup-skript for vdr-joystick
#
# zulio <zulio(at)zulinux.net>

plugin_pre_vdr_start() {

	add_plugin_param "-d ${VDR_JOYSTICK_DEVICE:=/dev/js0}"
}

