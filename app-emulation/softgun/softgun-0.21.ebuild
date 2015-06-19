# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/softgun/softgun-0.21.ebuild,v 1.1 2013/01/15 04:53:50 vapier Exp $

EAPI="4"

inherit toolchain-funcs eutils

DESCRIPTION="ARM software emulator"
HOMEPAGE="http://softgun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.21-make.patch
	sed -i \
		-e "/^CFLAGS/s:-O9.*-Werror:${CFLAGS}:" \
		config.mk || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/bin
	emake install prefix="${D}/usr"
	dodoc README configs/*.sg
}
