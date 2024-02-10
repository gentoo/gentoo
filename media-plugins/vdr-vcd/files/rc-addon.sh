# plugin-startup-skript for vcd-plugin

plugin_pre_vdr_start() {
	[ -e /etc/conf.d/vdr.cd-dvd ] && . /etc/conf.d/vdr.cd-dvd
	: ${VDR_CDREADER:=/dev/cdrom}
	: ${VCD_DEVICE:=${VDR_CDREADER}}
	add_plugin_param "--vcd ${VCD_DEVICE}"
}
