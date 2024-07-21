# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: VDR OSD access for ext. programs through a TCP/IP socket connection"
HOMEPAGE="https://www.udo-richter.de/vdr/osdserver.en.html"
SRC_URI=" https://www.udo-richter.de/vdr/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.1.1-gentoo.diff"
		"${FILESDIR}/${P}_gcc-6.patch" )

DOCS="examples/* README README.PERL-MODULE HISTORY"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/osdserver
	doins   "${FILESDIR}"/osdserverhosts.conf
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog "Check configuration files:"
	elog "/etc/vdr/plugins/osdserver/osdserverhosts.conf"
	elog "/etc/conf.d/vdr.osdserver"
	elog "Examples are in '/usr/share/doc/vdr/${P}/'"
}
