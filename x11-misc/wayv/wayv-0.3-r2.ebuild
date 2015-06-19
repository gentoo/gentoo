# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/wayv/wayv-0.3-r2.ebuild,v 1.4 2014/09/03 08:34:39 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Wayv is hand-writing/gesturing recognition software for X"
HOMEPAGE="http://www.stressbunny.com/wayv"
SRC_URI="http://www.stressbunny.com/gimme/wayv/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-proto/inputproto
	x11-proto/xproto
"

src_prepare() {
	sed -i -e 's| = -Wall -O2| += |g' src/Makefile* || die
	tc-export CC
}

src_install() {
	default

	cd doc
	default
	dodoc HOWTO*
}
