# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/softgun/softgun-0.22.ebuild,v 1.2 2015/06/04 15:18:10 pacho Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="ARM software emulator"
HOMEPAGE="http://softgun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.22-make.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/bin
	emake install prefix="${D}/usr"
	dodoc README configs/*.sg
}
