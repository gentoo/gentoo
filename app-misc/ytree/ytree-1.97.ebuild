# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ytree/ytree-1.97.ebuild,v 1.4 2014/01/17 17:54:51 creffett Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A (curses-based) file manager"
HOMEPAGE="http://www.han.de/~werner/ytree.html"
SRC_URI="http://www.han.de/~werner/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="
	sys-libs/readline
	sys-libs/ncurses
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.94-bindir.patch
}

pkg_setup() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}usr" install || die "emake install failed"
	dodoc ytree.conf
}
