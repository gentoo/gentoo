# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/conspy/conspy-1.10.ebuild,v 1.3 2015/06/26 08:56:08 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true
inherit autotools-utils

DESCRIPTION="Remote control for Linux virtual consoles"
HOMEPAGE="http://conspy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-1/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_configure() {
	autotools-utils_src_configure

	mv \
		"${WORKDIR}"/${P}_build/Makefile-automake \
		"${WORKDIR}"/${P}_build/Makefile || die
}

src_install() {
	dobin "${WORKDIR}"/${P}_build/${PN}
	doman ${PN}.1
	dodoc ChangeLog.txt README.txt
	dohtml ${PN}.html
}
