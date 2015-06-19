# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-menuorg/files/rc-addon.sh,v 1.1 2007/10/09 14:57:54 hd_brummy Exp $
#
# rc-addon plugin-startup-skript for vdr-menuorg
#
# Joerg Bornkessel <hd_brummy@gentoo.org>

plugin_pre_vdr_start() {

    add_plugin_param "-c /etc/vdr/plugins/menuorg/menuorg.xml"
}


