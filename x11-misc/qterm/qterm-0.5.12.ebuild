# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit cmake-utils eutils

DESCRIPTION="A BBS client for Linux"
HOMEPAGE="http://qterm.sourceforge.net"
SRC_URI="mirror://sourceforge/qterm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-qt/qtgui-4.5:4[qt3support]
	dev-libs/openssl"
DEPEND="${RDEPEND}
	kde-base/kdelibs
	dev-qt/qthelp:4
	dev-qt/qtwebkit:4"

src_prepare() {
	epatch "${FILESDIR}"/"${PN}"-0.5.11-gentoo.patch \
			"${FILESDIR}"/${P}-qt4.patch \
			"${FILESDIR}"/${P}-glibc216.patch
}

src_install() {
	cmake-utils_src_install
	mv "${D}"/usr/bin/qterm "${D}"/usr/bin/QTerm || die
	dodoc README TODO
}
