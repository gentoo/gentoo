#
# rc-addon-script for plugin newsticker
#

plugin_pre_vdr_start() {
	add_plugin_param "--output=/var/vdr/newsticker"
}
