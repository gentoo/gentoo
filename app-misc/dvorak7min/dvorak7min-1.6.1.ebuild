# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dvorak7min/dvorak7min-1.6.1.ebuild,v 1.16 2012/07/01 09:49:58 jlec Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Simple ncurses-based typing tutor for learning the Dvorak keyboard layout"
HOMEPAGE="http://www.linalco.com/comunidad.html"
SRC_URI="http://www.linalco.com/ragnar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	emake clean
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PROF="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ChangeLog README
}
