# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P=${PN}${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A curses based toolkit for tcl"
HOMEPAGE="http://www.ch-werner.de/ck/"
SRC_URI="
	http://www.ch-werner.de/ck/${MY_P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${P}-tcl8.6.patch.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-lang/tk
	sys-libs/ncurses[gpm]
	sys-libs/gpm
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${WORKDIR}"/${P}-tcl8.6.patch
	sed \
		-e "/^LIB_INSTALL_DIR/s:lib$:$(get_libdir):g" \
		-i Makefile.in || die
}

src_configure() {
	econf \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)" \
		--enable-shared
}

src_compile() {
	emake \
		CURSES_LIB_SWITCHES="$($(tc-getPKG_CONFIG) --libs ncursesw) -lgpm"
}
