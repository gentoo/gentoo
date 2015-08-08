# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Auto-sort channels.conf"
HOMEPAGE="http://www.copypointburscheid.de/linux/autosort.htm"
SRC_URI="http://www.copypointburscheid.de/linux/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.32"
RDEPEND="${DEPEND}"

src_install() {
	vdr-plugin-2_src_install
	insinto /etc/vdr/plugins
	doins examples/autosort.conf
}

pkg_preinst() {
	if [[ ! -L ${ROOT}/etc/vdr/channels.conf ]]; then
		cp "${ROOT}"/etc/vdr/channels.conf "${D}"/etc/vdr/channels.conf.autosort.bak
		fowners vdr:vdr /etc/vdr/channels.conf.autosort.bak
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst
	echo
	elog "You will find a backup of your channels.conf in /etc/vdr/channels.conf.autosort.bak"
	elog "Edit /etc/vdr/plugins/autosort.conf to fit your needs"
	ewarn "Important:"
	ewarn "Backup your channels.conf together with autosort.conf"
	ewarn "before making heavy changes to autosort.conf."
	echo
}
