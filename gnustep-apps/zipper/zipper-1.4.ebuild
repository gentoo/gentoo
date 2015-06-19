# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/zipper/zipper-1.4.ebuild,v 1.5 2012/09/23 07:52:35 phajdan.jr Exp $

EAPI=4

inherit gnustep-2

S=${WORKDIR}/${P/z/Z}

DESCRIPTION="Zipper is a tool for inspecting and extracting compressed archives"
HOMEPAGE="http://gap.nongnu.org/zipper"
SRC_URI="http://savannah.nongnu.org/download/gap/${P/z/Z}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

pkg_postinst() {
	gnustep-base_pkg_postinst

	elog "Optional archives programs zipper can use:"
	elog "app-arch/unzip	(ZIP files)"
	elog "app-arch/lha		(LZH archives)"
	elog "app-arch/unlzx	(Amiga LZX archives)"
	elog "app-arch/rar		(RAR files)"
}
