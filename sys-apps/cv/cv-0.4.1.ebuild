# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Coreutils Viewer: show progress for cp, rm, dd, and so forth"
HOMEPAGE="https://github.com/Xfennec/cv"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -i \
		-e '/LFLAGS/s:-lncurses:$(LDFLAGS) $(shell $(PKG_CONFIG) --libs ncurses):' \
		-e 's:CFLAGS=-g:CFLAGS+=:' \
		-e 's:gcc:$(CC):g' \
		Makefile || die
	tc-export CC PKG_CONFIG
}

src_install() {
	emake PREFIX="${D}/${EPREFIX}/usr" install
	dodoc README.md
}
