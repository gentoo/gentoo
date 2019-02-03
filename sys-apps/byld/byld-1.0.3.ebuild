# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="build a Linux distribution on a single floppy"
HOMEPAGE="http://byld.sourceforge.net/"
SRC_URI="mirror://sourceforge/byld/byld-${PV//./_}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
RESTRICT="strip" #252054

RDEPEND="sys-apps/util-linux"

src_install() {
	dodoc BYLDING CREDITS README INSTALL FHS PAKING
	rm MAKEDEV.8 BYLDING CREDITS README INSTALL FHS LICENSE PAKING

	insinto /usr/lib/${PN}
	doins -r .
}

pkg_postinst() {
	einfo "The build scripts have been placed in /usr/lib/${PN}"
	einfo "For documentation, see /usr/share/doc/${PF}"
}
