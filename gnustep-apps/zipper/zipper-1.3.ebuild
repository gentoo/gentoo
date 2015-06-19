# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/zipper/zipper-1.3.ebuild,v 1.4 2010/02/10 21:45:26 voyageur Exp $

inherit gnustep-2

S=${WORKDIR}/${PN/z/Z}

DESCRIPTION="Zipper is a tool for inspecting and extracting compressed archives"
HOMEPAGE="http://xanthippe.dyndns.org/Zipper/"
SRC_URI="http://xanthippe.dyndns.org/Zipper/${P/z/Z}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="gnustep-libs/renaissance"
RDEPEND="${DEPEND}"

pkg_postinst() {
	gnustep-base_pkg_postinst

	elog "Optional archives programs zipper can use:"
	elog "app-arch/unzip	(ZIP files)"
	elog "app-arch/lha		(LZH archives)"
	elog "app-arch/unlzx	(Amiga LZX archives)"
	elog "app-arch/rar		(RAR files)"
}
