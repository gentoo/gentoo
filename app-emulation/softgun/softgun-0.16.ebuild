# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/softgun/softgun-0.16.ebuild,v 1.2 2010/01/04 03:33:11 flameeyes Exp $

inherit toolchain-funcs

DESCRIPTION="ARM software emulator"
HOMEPAGE="http://softgun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/^CFLAGS/s:-O9.*-fomit-frame-pointer:${CFLAGS}:" \
		config.mk || die "sed config.mk failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dodir /usr/bin
	emake install prefix="${D}/usr" || die
	dodoc README configs/*.sg
}
