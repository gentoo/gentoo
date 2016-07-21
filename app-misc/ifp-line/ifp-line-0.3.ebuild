# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="iRiver iFP open-source driver"
HOMEPAGE="http://ifp-driver.sourceforge.net/"
SRC_URI="mirror://sourceforge/ifp-driver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-warnings.patch
}

src_install() {
	dobin ifp || die
	dodoc NEWS README TIPS ChangeLog
	doman ifp.1

	exeinto /usr/share/${PN}
	doexe nonroot.sh || die
}

pkg_postinst() {
	elog
	elog "To enable non-root usage of ${PN}, you use any of the following"
	elog "methods."
	elog
	elog " 1. Follow the TIPS file in"
	elog "      /usr/share/doc/${PF}"
	elog
	elog " 2. Run /usr/share/${PN}/nonroot.sh"
	elog
}
