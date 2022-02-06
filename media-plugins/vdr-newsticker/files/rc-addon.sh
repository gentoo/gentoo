#
# rc-addon-script for plugin newsticker
#

plugin_pre_vdr_start() {
	local vdr_user_home=$( getent passwd "vdr" | cut -d: -f6 )
	add_plugin_param "--output=${vdr_user_home}/newsticker"
}
