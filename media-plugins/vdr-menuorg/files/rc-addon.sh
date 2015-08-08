# $Id$
#
# rc-addon plugin-startup-skript for vdr-menuorg
#
# Joerg Bornkessel <hd_brummy@gentoo.org>

plugin_pre_vdr_start() {

    add_plugin_param "-c /etc/vdr/plugins/menuorg/menuorg.xml"
}


