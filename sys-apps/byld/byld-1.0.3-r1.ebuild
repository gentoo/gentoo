# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Build a Linux distribution on a single floppy"
HOMEPAGE="https://byld.sourceforge.net/"
SRC_URI="mirror://sourceforge/byld/byld-${PV//./_}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
# bug #252054
RESTRICT="strip"

RDEPEND="sys-apps/util-linux
	sys-libs/libtermcap-compat"

QA_PREBUILT="*"

src_install() {
	dodoc BYLDING CREDITS README INSTALL FHS PAKING
	rm MAKEDEV.8 BYLDING CREDITS README INSTALL FHS LICENSE PAKING || die

	insinto /usr/lib/${PN}
	doins -r .
}

pkg_postinst() {
	einfo "The build scripts have been placed in /usr/lib/${PN}"
	einfo "For documentation, see /usr/share/doc/${PF}"
}
