# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="sc is a free curses-based spreadsheet program that uses key bindings similar to vi and less"
SRC_URI="ftp://ibiblio.org/pub/Linux/apps/financial/spreadsheet/${P}.tar.gz"
HOMEPAGE="http://ibiblio.org/pub/Linux/apps/financial/spreadsheet/"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="amd64 ppc sparc x86"

COMMON_DEPEND=">=sys-libs/ncurses-5.2"
DEPEND="virtual/pkgconfig"
RDEPEND="
	${COMMON_DEPEND}
	!dev-lang/stratego"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-amd64.patch \
		"${FILESDIR}"/${P}-lex-syntax.patch

	sed -i \
		-e "/^prefix=/ s:/usr:${D}/usr:" \
		-e "/^MANDIR=/ s:${prefix}/man:${prefix}/share/man:" \
		-e "/^LIBDIR=/ s:${prefix}/lib:${prefix}/$(get_libdir):" \
		-e '/^LIB=/s|-lncurses|$(shell ${PKG_CONFIG} --libs ncurses)|g' \
		-e "/^CC=/ s:gcc:$(tc-getCC):" \
		-e "/^CFLAGS/ s:=-DSYSV3 -O2 -pipe:+=-DSYSV3:" \
		-e "/strip/ s:^:#:g" \
		Makefile || die

}

src_compile() {
	tc-export PKG_CONFIG
	# no autoconf
	emake prefix="${D}"/usr || die
}

src_install () {
	# yes the makefile is so dumb it can't even make it's own dirs
	dodir /usr/bin
	dodir /usr/$(get_libdir)/sc
	dodir /usr/share/man/man1
	emake install

	sed -i -e "s:${D}::g" sc.1 || die
	doman sc.1 psc.1

	dodoc CHANGES README sc.doc psc.doc tutorial.sc
	dodoc VMS_NOTES ${P}.lsm TODO SC.MACROS
}
