# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: server part for MediaMVP device"
HOMEPAGE="http://www.loggytronic.com/vomp.php"
SRC_URI="http://www.loggytronic.com/dl/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND=">=media-video/vdr-2.4.1"

KEEP_I18NOBJECT="yes"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/vompserver
	newins vomp.conf.sample vomp.conf
	newins vomp-00-00-00-00-00-00.conf.sample vomp-00-00-00-00-00-00.conf
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog "\nHave a look to the VOMP sample files in /etc/vdr/plugins.\n"
}
